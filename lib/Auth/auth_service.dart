import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// Следим за состоянием авторизации
  static Stream<User?> authState() => _auth.authStateChanges();

  /// Регистрация + создание документа в Firestore
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
      'email': email,
      'name': name,
      'role': 'student',
      'createdAt': FieldValue.serverTimestamp(),
      'settings': {'locale': 'ru'},
    });

    return cred;
  }

  /// Вход
  static Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
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
}
