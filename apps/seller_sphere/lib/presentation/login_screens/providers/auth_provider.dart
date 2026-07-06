import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Definisikan state untuk autentikasi.
class AuthState {
  final bool isAuthenticated;
  AuthState(this.isAuthenticated);
}

// 2. Buat Notifier untuk mengelola state autentikasi.
class AuthNotifier extends StateNotifier<AuthState> {
  // Inisialisasi state awal (pengguna belum terautentikasi).
  AuthNotifier() : super(AuthState(false));

  // ======== PERBAIKAN: Tambahkan getter di sini ======== //
  /// Getter untuk memeriksa status autentikasi dari luar notifier.
  bool get isAuthenticated => state.isAuthenticated;
  // ==================================================== //

  /// Simulasi proses login.
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'seller@example.com' && password == 'password123') {
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
