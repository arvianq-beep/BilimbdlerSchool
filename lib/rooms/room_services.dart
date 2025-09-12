import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ... твой существующий RoomService

class RoomService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<User> _ensureUser() async {
    final u = _auth.currentUser;
    if (u != null) return u;
    return (await _auth.signInAnonymously()).user!;
  }

  // 👉 вызывать, когда игрок завершил игру
  static Future<void> submitResult({
    required String roomId,
    required int score,
    required int total,
    String? displayName,
  }) async {
    final user = await _ensureUser();
    final memRef = _db
        .collection('rooms')
        .doc(roomId)
        .collection('members')
        .doc(user.uid);
    await memRef.set({
      if (displayName != null && displayName.isNotEmpty) 'name': displayName,
      'score': score,
      'total': total,
      'finishedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // необязательно: трекнуть обновление комнаты
    await _db.collection('rooms').doc(roomId).set({
      'lastResultAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
