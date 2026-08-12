import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream untuk memantau perubahan status otentikasi pengguna[cite: 4]
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan pengguna yang sedang login[cite: 4]
  User? get currentUser => _auth.currentUser;

  // Cek status login[cite: 4]
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Fungsi Login[cite: 4]
  Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  // Fungsi Register Akun[cite: 4]
  Future<UserCredential> createUserAccount(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  // Fungsi Kirim Email Reset Password[cite: 4]
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Fungsi Logout[cite: 4]
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}