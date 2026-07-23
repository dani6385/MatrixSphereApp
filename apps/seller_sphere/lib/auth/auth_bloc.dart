import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seller_sphere/auth/auth_service.dart';

part '../screens/login/data/auth_event.dart';
part '../screens/login/data/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
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
      await _authService.register(event.name, event.email, event.password);
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