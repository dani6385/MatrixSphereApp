import 'package:bloc/bloc.dart';

import 'package:seller_sphere/screens/login/auth_bloc.dart';

part '../auth_event.dart';
part '../auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Simulasi panggilan API
      await Future.delayed(const Duration(seconds: 2));

      if (event.email == 'admin@example.com' && event.password == 'password123') {
        emit(const AuthSuccess('Login berhasil!'));
      } else {
        emit(const AuthFailure('Email atau password salah.'));
      }
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
      // Simulasi panggilan API untuk registrasi
      await Future.delayed(const Duration(seconds: 2));

      // Anggap registrasi selalu berhasil dalam simulasi ini
      emit(const AuthSuccess('Registrasi berhasil! Silakan login.'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}