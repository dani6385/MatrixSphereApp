// lib/features/auth/login/login_state.dart
import 'package:flutter/material.dart';

class LoginState {
  bool isLoading;
  bool isPasswordVisible;
  bool rememberMe;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  LoginState({
    required this.isLoading,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  // Fungsi pembantu untuk menyalin state saat terjadi perubahan (immutability helper)
  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? rememberMe,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      emailController: emailController,
      passwordController: passwordController,
      formKey: formKey,
    );
  }
}