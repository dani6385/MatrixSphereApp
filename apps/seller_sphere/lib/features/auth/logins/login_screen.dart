// lib/features/auth/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:seller_sphere/widgets/logo.dart';
import 'package:shared_services/shared_services.dart';
import 'states/login_state.dart';
import 'logics/login_logic.dart';
import 'widgets/login_body.dart';
import 'widgets/login_form_fields.dart';
import 'widgets/login_header.dart';
import 'widgets/login_loading_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginLogic _loginLogic = LoginLogic();

  // Inisialisasi state login
  late final LoginState _loginState;

  @override
  void initState() {
    super.initState();
    _loginState = LoginState(
      isLoading: true,
      isPasswordVisible: false,
      rememberMe: false,
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      formKey: GlobalKey<FormState>(),
    );

    _loadSavedCredentialsAndInitSession();
  }

  @override
  void dispose() {
    _loginState.emailController.dispose();
    _loginState.passwordController.dispose();
    super.dispose();
  }

  // Fungsi baru untuk memuat kredensial sebelum inisialisasi sesi
  void _loadSavedCredentialsAndInitSession() async {
    final credentials = await LocalAuthStorage.getCredentials();
    final savedEmail = credentials['email'];
    final savedPassword = credentials['password'];

    if (savedEmail != null && savedPassword != null) {
      if (mounted) {
        setState(() {
          _loginState.emailController.text = savedEmail;
          _loginState.passwordController.text = savedPassword;
          _loginState.rememberMe = true;
        });
      }
    }

    _loginLogic.initSession(
      setLoading: (loading) => setState(() => _loginState.isLoading = loading),
      onLoggedIn: () {
        if (!mounted) return;
        // Navigasi ditangani otomatis oleh app_router atau go_router
      }, // Pastikan initSession tidak lagi memuat kredensial
    );
  }

  void _handleLoginPressed() {
    if (_loginState.formKey.currentState?.validate() ?? false) {
      _loginLogic.login(
        email: _loginState.emailController.text.trim(),
        password: _loginState.passwordController.text,
        rememberMe: _loginState.rememberMe, // Kirim status rememberMe ke logic
        context: context,
        setLoading: (loading) => setState(() => _loginState.isLoading = loading),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loginState.isLoading) {
      return const LoginLoadingBody();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoginHeader(),
              const Logo(),
              LoginBody(
                onLogin: _handleLoginPressed,
                formFields: LoginFormFields(
                  formKey: _loginState.formKey,
                  isLoading: _loginState.isLoading,
                  emailController: _loginState.emailController,
                  passwordController: _loginState.passwordController,
                  isPasswordVisible: _loginState.isPasswordVisible,
                  rememberMe: _loginState.rememberMe,
                  onLoginPressed: _handleLoginPressed,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _loginState.isPasswordVisible = !_loginState.isPasswordVisible;
                    });
                  },
                  onRememberMeChanged: (bool? value) {
                    setState(() {
                      _loginState.rememberMe = value ?? false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}