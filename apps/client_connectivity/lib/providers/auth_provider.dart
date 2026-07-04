import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Definisikan state untuk autentikasi.
class AuthState {
  final bool isAuthenticated;
  AuthState(this.isAuthenticated);
}

// 2. Buat Notifier untuk mengelola state autentikasi.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(false));

  /// Simulasi proses login.
  Future<void> login(String email, String password) async {
    // Simulasi penundaan jaringan.
    await Future.delayed(const Duration(seconds: 1));

    // Logika validasi dummy untuk klien.
    if (email == 'client@example.com' && password == 'password') {
      state = AuthState(true);
    } else {
      throw Exception('Email atau password salah.');
    }
  }

  /// Proses logout.
  void logout() {
    state = AuthState(false);
  }
}

// 3. Buat StateNotifierProvider global.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
