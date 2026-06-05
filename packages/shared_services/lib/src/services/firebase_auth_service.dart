import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan stream status user (login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Fungsi Login
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print("Error login: $e");
      return null;
    }
  }

  // Fungsi Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
