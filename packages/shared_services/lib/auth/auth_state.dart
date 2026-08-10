part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];

  Object? get status => null;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  @override
  List<Object> get props => [error];
}
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
  @override
  List<Object> get props => [];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
  @override
  List<Object> get props => [];
}
