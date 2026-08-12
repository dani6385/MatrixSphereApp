// lib/features/auth/login/login_logic.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class LoginLogic {
  final AuthService _authService = AuthService();

  /// Memeriksa status login awal pengguna via Firebase
  Future<void> initSession({
    required void Function(bool isLoading) setLoading,
    required VoidCallback onLoggedIn,
  }) async {
    final isLoggedIn = _authService.isLoggedIn();
    if (isLoggedIn) {
      if (kDebugMode) {
        print(
            'User is already logged in via Firebase. Navigating via GoRouter.');
      }
      onLoggedIn();
    } else {
      setLoading(false);
    }
  }

  /// Memproses fungsi login menggunakan Firebase
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required void Function(bool isLoading) setLoading,
    required bool rememberMe,
  }) async {
    setLoading(true);

    try {
      // Panggil AuthService untuk login
      await _authService.login(
          email, password); // Menggunakan metode login dari AuthService

      // Jika login berhasil, kelola kredensial berdasarkan pilihan 'Remember Me'
      if (rememberMe) {
        await LocalAuthStorage.saveCredentials(email, password);
      } else {
        await LocalAuthStorage.clearCredentials();
      }

      if (kDebugMode) {
        print('Login successful! Firebase user authenticated.');
      }
      if (context.mounted) {
        // Navigasi tidak diperlukan di sini.
        // AuthService akan memberi notifikasi ke GoRouter,
        // dan GoRouter akan secara otomatis mengarahkan pengguna
        // berdasarkan logika redirect di app_router.dart.
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Login failed: ${e.toString().replaceAll("Exception: ", "")}')),
      );
    }

    // Set loading ke false di sini agar dieksekusi baik saat sukses maupun gagal,
    // kecuali jika navigasi terjadi (yang akan membongkar widget ini).
    if (context.mounted) {
      setLoading(false);
    }
  }
}
