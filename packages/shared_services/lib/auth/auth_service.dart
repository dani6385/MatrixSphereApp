import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahan untuk memori lokal
import 'package:shared_logics/shared_logics.dart';
import 'package:shared_utils/shared_utils.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();

  static const String prefRememberMeKey = 'auth_remember_me';
  static const String prefSavedEmailKey = 'auth_saved_email';
  static const String prefSavedPasswordKey = 'auth_saved_password';

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Cek status login
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Fungsi Login yang Diperbarui dengan Penyimpanan Token
  Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Ambil dan simpan token ke SharedPreferences
      if (credential.user != null) {
        String? token = await credential.user!.getIdToken();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token ?? '');
      }

      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    try {
      // Memanggil logika dari AuthController
      var result = await _authController.validateAndLogin(email, password);

      if (result['success'] == true) {
        String role = result['role'];
        if (role == 'admin') {
          // Navigasi atau penanganan admin
        } else {
          // Navigasi atau penanganan member
        }
      }
    } catch (e) {
      // Memanggil Dialog Helper untuk menampilkan pesan error ke UI
      UiHelper.showSnackBar(
          context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Fungsi Register Akun yang Diperbarui dengan Penyimpanan Token[cite: 1]
  Future<UserCredential> createUserAccount(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Ambil dan simpan token untuk akun baru
      if (userCredential.user != null) {
        String? token = await userCredential.user!.getIdToken();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token ?? '');
      }

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  // Fungsi Kirim Email Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Fungsi Logout yang Diperbarui (Menghapus Token)[cite: 1]
  Future<void> logout() async {
    // Hapus token dari memori lokal saat logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');

    await _auth.signOut();
    notifyListeners();
  }

  Future<Map<String, dynamic>> loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isRemembered = prefs.getBool(prefRememberMeKey) ?? false;

      if (isRemembered) {
        return {
          'rememberMe': true,
          'email': prefs.getString(prefSavedEmailKey) ?? '',
          'password': prefs.getString(prefSavedPasswordKey) ?? '',
        };
      }
    } catch (_) {}
    return {'rememberMe': false, 'email': '', 'password': ''};
  }

  Future<void> saveOrClearCredentials(
      bool rememberMe, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setBool(prefRememberMeKey, true);
        await prefs.setString(prefSavedEmailKey, email.trim());
        await prefs.setString(prefSavedPasswordKey, password);
      } else {
        await prefs.setBool(prefRememberMeKey, false);
        await prefs.remove(prefSavedEmailKey);
        await prefs.remove(prefSavedPasswordKey);
      }
    } catch (_) {}
  }

  Future<void> registerShop(
      {required User user, required String shopName}) async {}
  String handleAuthError(FirebaseAuthException e) {
    return _authController.handleAuthError(e);
  }
}
