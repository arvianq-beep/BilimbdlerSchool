// lib/Services/room_services.dart
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

  /// Создать комнату (группа) c лимитом и предметом
  static Future<DocumentReference<Map<String, dynamic>>> createRoom({
    required int maxMembers, // 2..7
    required String subject, // 'physical' | 'economic'
  }) async {
    final me = await _ensureUser();

    // генерим уникальный код
    String code = '';
    for (var i = 0; i < 5; i++) {
      code = _code();
      final clash = await _db
          .collection('rooms')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (clash.size == 0) break;
      if (i == 4) throw Exception('Не удалось сгенерировать код');
    }

    final roomRef = _db.collection('rooms').doc();
    await _db.runTransaction((tx) async {
      tx.set(roomRef, {
        'code': code,
        'ownerUid': me.uid,
        'subject': subject, // <—
        'status': 'waiting', // waiting | started
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

  /// Войти по коду (проверка вместимости)
  static Future<DocumentReference<Map<String, dynamic>>> joinByCode(
    String code,
  ) async {
    final me = await _ensureUser();

    final qs = await _db
        .collection('rooms')
        .where('code', isEqualTo: code.trim().toUpperCase())
        .limit(1)
        .get();
    if (qs.size == 0) throw Exception('Комната не найдена');

    final roomRef = qs.docs.first.reference;

    await _db.runTransaction((tx) async {
      final roomSnap = await tx.get(roomRef);
      final data = roomSnap.data()! as Map<String, dynamic>;
      if (data['status'] == 'started') throw Exception('Игра уже начата');
      if (data['isOpen'] != true) throw Exception('Комната закрыта');

      final max = (data['maxMembers'] ?? 0) as int;
      final count = (data['memberCount'] ?? 0) as int;

      final meRef = roomRef.collection('members').doc(me.uid);
      final meSnap = await tx.get(meRef);

      if (!meSnap.exists) {
        if (count >= max) throw Exception('Мест нет');
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

  /// Запустить игру (только владелец)
  static Future<void> startRoom(String roomId) async {
    await _db.collection('rooms').doc(roomId).update({
      'status': 'started',
      'startedAt': FieldValue.serverTimestamp(),
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
}
