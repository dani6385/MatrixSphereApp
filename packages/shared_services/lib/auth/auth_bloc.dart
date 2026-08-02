import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:shared_services/auth/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.login(event.email, event.password);
      emit(const AuthSuccess('Login berhasil!'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Langkah 1: Buat akun pengguna di Firebase Auth
      final userCredential =
          await _authService.createUserAccount(event.email, event.password);
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Gagal membuat akun, data pengguna tidak ditemukan.");
      }

      // Langkah 2: Daftarkan detail toko di Realtime Database
      await _authService.registerShop(user: user, shopName: event.name);
      emit(const AuthSuccess('Registrasi berhasil! Silakan login.'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      emit(AuthInitial()); // Kembali ke state awal setelah logout
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
