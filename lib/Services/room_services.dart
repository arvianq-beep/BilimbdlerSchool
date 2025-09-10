import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<User> _ensureUser() async {
    final u = _auth.currentUser;
    if (u != null) return u;
    return (await _auth.signInAnonymously()).user!;
  }

  static String _code([int len = 6]) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    return List.generate(len, (_) => chars[r.nextInt(chars.length)]).join();
  }

  static String _tag(String uid, {int len = 6}) =>
      uid.substring(uid.length - len).toUpperCase();

  /// Создать комнату (2..7) и сохранить предмет
  static Future<DocumentReference<Map<String, dynamic>>> createRoom({
    required int maxMembers, // 2..7
    required String subject, // 'physical' | 'economic'
  }) async {
    final me = await _ensureUser();

    // сгенерить уникальный код
    String code = '';
    for (var i = 0; i < 5; i++) {
      code = _code();
      final clash = await _db
          .collection('rooms')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (clash.size == 0) break;
      if (i == 4) {
        throw FirebaseException(plugin: 'rooms', code: 'codeGenerationFailed');
      }
    }

    final roomRef = _db.collection('rooms').doc();
    await _db.runTransaction((tx) async {
      tx.set(roomRef, {
        'code': code,
        'ownerUid': me.uid,
        'subject': subject,
        'status': 'waiting', // waiting | playing
        'isOpen': true,
        'maxMembers': maxMembers,
        'memberCount': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.set(roomRef.collection('members').doc(me.uid), {
        'uid': me.uid,
        'role': 'owner',
        'tag': _tag(me.uid),
        'joinedAt': FieldValue.serverTimestamp(),
      });
    });

    return roomRef;
  }

  /// Войти по коду (проверка вместимости/статуса)
  static Future<DocumentReference<Map<String, dynamic>>> joinByCode(
    String code,
  ) async {
    final me = await _ensureUser();

    final qs = await _db
        .collection('rooms')
        .where('code', isEqualTo: code.trim().toUpperCase())
        .limit(1)
        .get();
    if (qs.size == 0) {
      throw FirebaseException(plugin: 'rooms', code: 'roomNotFound');
    }

    final roomRef = qs.docs.first.reference;

    await _db.runTransaction((tx) async {
      final roomSnap = await tx.get(roomRef);
      final data = roomSnap.data()! as Map<String, dynamic>;
      if (data['status'] == 'playing') {
        throw FirebaseException(plugin: 'rooms', code: 'roomAlreadyStarted');
      }
      if (data['isOpen'] != true) {
        throw FirebaseException(plugin: 'rooms', code: 'roomIsClosed');
      }

      final max = (data['maxMembers'] ?? 0) as int;
      final count = (data['memberCount'] ?? 0) as int;

      final meRef = roomRef.collection('members').doc(me.uid);
      final meSnap = await tx.get(meRef);

      if (!meSnap.exists) {
        if (count >= max) {
          throw FirebaseException(plugin: 'rooms', code: 'roomIsFull');
        }
        tx.set(meRef, {
          'uid': me.uid,
          'role': 'member',
          'tag': _tag(me.uid),
          'joinedAt': FieldValue.serverTimestamp(),
        });
        tx.update(roomRef, {'memberCount': FieldValue.increment(1)});
      }
    });

    return roomRef;
  }

  /// Выйти из комнаты
  static Future<void> leaveRoom(String roomId) async {
    final me = await _ensureUser();
    final roomRef = _db.collection('rooms').doc(roomId);
    await _db.runTransaction((tx) async {
      final meRef = roomRef.collection('members').doc(me.uid);
      if ((await tx.get(meRef)).exists) {
        tx.delete(meRef);
        tx.update(roomRef, {'memberCount': FieldValue.increment(-1)});
      }
    });
  }

  /// Запустить выбранную игру (владелец)
  static Future<void> startGame({
    required String roomId,
    required String gameId, // capitals/flags/... или экономические id
  }) async {
    await _db.collection('rooms').doc(roomId).update({
      'status': 'playing',
      'currentGame': {'id': gameId, 'startedAt': FieldValue.serverTimestamp()},
    });
  }

  /// (опц.) Сбросить игру и вернуться к ожиданию
  static Future<void> resetGame(String roomId) async {
    await _db.collection('rooms').doc(roomId).update({
      'status': 'waiting',
      'currentGame': FieldValue.delete(),
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> roomStream(
    String roomId,
  ) => _db.collection('rooms').doc(roomId).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> membersStream(
    String roomId,
  ) => _db
      .collection('rooms')
      .doc(roomId)
      .collection('members')
      .orderBy('joinedAt')
      .snapshots();
}
