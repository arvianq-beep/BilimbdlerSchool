import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// Подписка на состояние авторизации
  static Stream<User?> authState() => _auth.authStateChanges();

  /// Регистрация email+password + профиль в Firestore
  static Future<UserCredential> signUp(
    String email,
    String password, {
    String? name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'email': email,
      'name': name,
      'firstName': null,
      'lastName': null,
      'role': 'student',
      'guest': false,
      'guestId': null,
      'guestLabel': null,
      'search': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'settings': {'locale': 'en'},
    });

    return cred;
  }

  /// Вход по email+password
  static Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// ГОСТЕВОЙ ВХОД (анонимно) + профиль с локалью и локализованной меткой guestLabel
  static Future<UserCredential> signInAnonymously({String? locale}) async {
    final cred = await _auth.signInAnonymously();
    final u = cred.user!;
    final ref = _db.collection('users').doc(u.uid);
    final snap = await ref.get();

    final lang = (locale ?? 'en').toLowerCase();

    if (!snap.exists) {
      final id = _shortId(length: 8);
      await ref.set({
        'uid': u.uid,
        'email': null,
        'name': null,
        'firstName': null,
        'lastName': null,
        'role': 'guest',
        'guest': true,
        'guestId': id,
        'guestLabel': _buildGuestLabel(
          id: id,
          locale: lang,
        ), // локализованная подпись
        'search': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'settings': {'locale': lang},
      });
    } else {
      final data = snap.data()!;
      final id = (data['guestId'] as String?) ?? _shortId(length: 8);
      await ref.set({
        'role': 'guest',
        'guest': true,
        'guestId': id,
        'guestLabel': _buildGuestLabel(id: id, locale: lang),
        'settings': {'locale': lang},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return cred;
  }

  /// Обновить локаль пользователя (и guestLabel, если он гость)
  static Future<void> setUserLocale(String locale) async {
    final u = _auth.currentUser;
    if (u == null) return;
    final lang = locale.toLowerCase();
    final ref = _db.collection('users').doc(u.uid);
    final snap = await ref.get();
    if (!snap.exists) return;
    final data = snap.data()!;
    final isGuest = data['guest'] == true;
    final guestId = data['guestId'] as String?;

    await ref.set({
      'settings': {'locale': lang},
      if (isGuest && guestId != null)
        'guestLabel': _buildGuestLabel(id: guestId, locale: lang),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Текущий профиль (для префилла и пр.)
  static Future<Map<String, dynamic>?> getCurrentProfile() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final snap = await _db.collection('users').doc(u.uid).get();
    return snap.data();
  }

  /// Вернуть guestId (короткий код)
  static Future<String?> getGuestId() async {
    final profile = await getCurrentProfile();
    return profile?['guestId'] as String?;
  }

  /// Обновить профиль: имя/фамилия + индекс поиска
  static Future<void> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    final u = _auth.currentUser;
    if (u == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'No user',
      );
    }

    final f = firstName?.trim();
    final l = lastName?.trim();
    final full = [f, l].where((x) => x != null && x.isNotEmpty).join(' ');

    final firstLower = f?.toLowerCase();
    final lastLower = l?.toLowerCase();
    final nameLower = full.isEmpty ? null : full.toLowerCase();

    final search = _buildSearchIndex(
      pieces: [
        if (firstLower != null) firstLower,
        if (lastLower != null) lastLower,
        if (nameLower != null) nameLower,
      ],
    );

    await _db.collection('users').doc(u.uid).set({
      'firstName': f,
      'lastName': l,
      'name': full.isEmpty ? null : full,
      'firstNameLower': firstLower,
      'lastNameLower': lastLower,
      'nameLower': nameLower,
      'search': search,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Поиск пользователей по префиксу имени/фамилии/ФИО
  static Stream<QuerySnapshot<Map<String, dynamic>>> searchUsersByNamePrefix(
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return _db.collection('users').limit(20).snapshots();
    }
    return _db
        .collection('users')
        .where('search', arrayContains: q)
        .limit(50)
        .snapshots();
  }

  /// Линкануть анонимный аккаунт к email+password (апгрейд без потери данных)
  static Future<UserCredential> linkAnonymousWithEmail(
    String email,
    String password, {
    String? name,
  }) async {
    final u = _auth.currentUser;
    if (u == null || !u.isAnonymous) {
      throw FirebaseAuthException(
        code: 'not-anonymous',
        message: 'User is not anonymous',
      );
    }
    final cred = EmailAuthProvider.credential(email: email, password: password);
    final linked = await u.linkWithCredential(cred);

    await _db.collection('users').doc(u.uid).set({
      'email': email,
      'name': name,
      'role': 'student',
      'guest': false,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return linked;
  }

  /// Сброс пароля
  static Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  /// Отправка письма подтверждения
  static Future<void> sendEmailVerification() async {
    final u = _auth.currentUser;
    if (u != null && !u.emailVerified) await u.sendEmailVerification();
  }

  /// Выход
  static Future<void> signOut() => _auth.signOut();

  // ===== helpers =====
  static String _shortId({int length = 8}) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // без похожих символов
    final rnd = Random.secure();
    return List.generate(
      length,
      (_) => chars[rnd.nextInt(chars.length)],
    ).join();
  }

  static List<String> _buildSearchIndex({required List<String> pieces}) {
    final set = <String>{};
    for (final p in pieces) {
      final s = p.trim();
      if (s.isEmpty) continue;
      final words = s.split(RegExp(r'\s+'));
      for (final w in words) {
        var acc = '';
        for (final r in w.runes) {
          acc += String.fromCharCode(r);
          set.add(acc); // i, iv, iva, ivan...
        }
      }
    }
    return set.toList();
  }

  static String _buildGuestLabel({required String id, required String locale}) {
    switch (locale) {
      case 'ru':
        return 'Гость ID: $id';
      case 'kk':
        return 'Қонақ ID: $id';
      default:
        return 'Guest ID: $id';
    }
  }
}
