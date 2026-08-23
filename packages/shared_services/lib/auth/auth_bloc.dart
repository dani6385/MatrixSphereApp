import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_services/shared_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final ShopService shopService = ShopService();

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
      final userCredential = await _authService.login(event.email, event.password);
      
      // Log analytics event for successful login
      analyticsService.logLogin('email_password');

      // Set user property to identify them in analytics
      if (userCredential.user != null) {
        analyticsService.setUserProperty(name: 'user_id', value: userCredential.user!.uid);
      }

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
      final userCredential =
          await _authService.createUserAccount(event.email, event.password);
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Gagal membuat akun, data pengguna tidak ditemukan.");
      }

      // Log analytics event for successful sign-up
      analyticsService.logSignUp('email_password');

      // Set user property upon registration
      analyticsService.setUserProperty(name: 'user_id', value: user.uid);

      await shopService.createInitialShopEntry(
          user: user, shopName: event.name);
          
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
      // Clear user-specific properties on logout
      analyticsService.setUserProperty(name: 'user_id', value: null);
      analyticsService.setUserProperty(name: 'has_shop', value: null); // Jika Anda melacak ini

      await _authService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
