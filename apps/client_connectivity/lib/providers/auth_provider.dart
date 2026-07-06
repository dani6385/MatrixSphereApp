import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Definisikan state untuk autentikasi.
/// Merepresentasikan state dari proses autentikasi.
/// Menggunakan sealed class untuk menangani berbagai kondisi (initial, loading, success, error)
/// dengan cara yang type-safe.
abstract class AuthProcessState {
  const AuthProcessState();
}

class AuthInitial extends AuthProcessState { const AuthInitial(); }
class AuthLoading extends AuthProcessState { const AuthLoading(); }
class AuthSuccess extends AuthProcessState { const AuthSuccess(); }
class AuthError extends AuthProcessState { final String message; const AuthError(this.message); }

class AuthState {
  final bool isAuthenticated;
  final AuthProcessState loginProcessState;
  AuthState({this.isAuthenticated = false, this.loginProcessState = const AuthInitial()});
}

// 2. Buat Notifier untuk mengelola state autentikasi.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  /// Simulasi proses login.
  Future<void> login(String email, String password) async {
    state = AuthState(isAuthenticated: false, loginProcessState: const AuthLoading());
    try {
      // Simulasi penundaan jaringan.
      await Future.delayed(const Duration(seconds: 1));
      // Logika validasi dummy untuk klien.
      if (email == 'client@example.com' && password == 'password') {
        state = AuthState(isAuthenticated: true, loginProcessState: const AuthSuccess());
      } else {
        throw Exception('Email atau password salah.');
      }
    } catch (e) {
      state = AuthState(isAuthenticated: false, loginProcessState: AuthError(e.toString()));
    }
  }

  /// Simulasi proses login menggunakan voucher.
  Future<void> loginWithVoucher(String voucherCode) async {
    state = AuthState(isAuthenticated: false, loginProcessState: const AuthLoading());
    try {
      // Simulasi penundaan jaringan.
      await Future.delayed(const Duration(milliseconds: 1200));

      // Logika validasi dummy untuk voucher.
      if (voucherCode.trim().isNotEmpty) {
        state = AuthState(isAuthenticated: true, loginProcessState: const AuthSuccess());
      } else {
        throw Exception('Kode voucher tidak valid.');
      }
    } catch (e) {
      state = AuthState(isAuthenticated: false, loginProcessState: AuthError(e.toString()));
    }
  }

  /// Simulasi proses aktivasi trial.
  Future<void> startTrial() async {
    state = AuthState(isAuthenticated: false, loginProcessState: const AuthLoading());
    try {
      // Simulasi penundaan jaringan.
      await Future.delayed(const Duration(milliseconds: 1000));

      // Trial selalu berhasil dalam simulasi ini.
      state = AuthState(isAuthenticated: true, loginProcessState: const AuthSuccess());
    } catch (e) {
      state = AuthState(isAuthenticated: false, loginProcessState: AuthError(e.toString()));
    }
  }

  /// Proses logout.
  void logout() {
    state = AuthState();
  }
}

// 3. Buat StateNotifierProvider global.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
