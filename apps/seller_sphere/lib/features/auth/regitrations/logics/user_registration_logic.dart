
// lib/features/auth/user_registration/user_registration_logic.dart
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import '../states/user_registration_state.dart';

class UserRegistrationLogic {
  final AuthService _authService = AuthService();

  /// Menangani proses registrasi pengguna baru
  Future<void> registerUser({
    required BuildContext context,
    required UserRegistrationState state,
    required VoidCallback onUpdate,
  }) async {
    if (state.formKey.currentState?.validate() ?? false) {
      onUpdate(); // Memperbarui state untuk menampilkan loading

      try {
        // Panggil AuthService untuk membuat akun
        final userCredential = await _authService.createUserAccount(
          state.emailController.text.trim(),
          state.passwordController.text,
        );

        // Simpan ID pengguna setelah registrasi berhasil
        if (userCredential.user != null) {
          await LocalAuthStorage.saveUserId(userCredential.user!.uid);
        }

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
        );
        // Jangan panggil context.pop().
        // AuthService akan memberi notifikasi ke GoRouter,
        // dan GoRouter akan secara otomatis mengarahkan pengguna
        // ke halaman yang benar (pendaftaran toko atau home)
        // berdasarkan logika di app_router.dart.
      } on Exception catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
        );
      } finally {
        onUpdate(); // Mematikan status loading
      }
    }
  }
}
