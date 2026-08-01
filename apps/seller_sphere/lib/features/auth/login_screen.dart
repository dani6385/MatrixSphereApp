// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Memuat status "Remember Me", email, dan password yang tersimpan.
  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      final String? email = prefs.getString('rememberedEmail');
      // Membaca password terenkripsi dari secure storage
      final credentials = await LocalAuthStorage.getCredentials();
      
      setState(() {
        _emailController.text = email ?? '';
        _passwordController.text = credentials['password'] ?? '';
        _rememberMe = true;
      });
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Memberitahu sistem untuk menyimpan data autofill, memicu password manager.
      TextInput.finishAutofillContext();

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        await _authService.login(email, password);

        // Simpan atau hapus preferensi "Remember Me" dan Secure Credentials
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setBool('rememberMe', true);
          await prefs.setString('rememberedEmail', email);
          // Simpan password secara aman menggunakan LocalAuthStorage
          await LocalAuthStorage.saveCredentials(email, password);
        } else {
          await prefs.remove('rememberMe');
          await prefs.remove('rememberedEmail');
          // Hapus kredensial tersimpan jika opsi dimatikan
          await LocalAuthStorage.clearCredentials();
        }

        // Navigasi akan ditangani oleh AuthWrapper atau redirect GoRouter
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.darkScaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.storefront, size: 80, color: kBrandPrimary),
                const SizedBox(height: 16),
                const Text(
                  'Selamat Datang di Seller Sphere',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kLightTextPrimary),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  autofillHints: const [AutofillHints.email, AutofillHints.username],
                  decoration: const InputDecoration(
                    labelText: 'Email / Username',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Email tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(
                    labelText: 'Kata Sandi',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) => (value?.isEmpty ?? true) ? 'Password tidak boleh kosong' : null,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: kBrandPrimary,
                      checkColor: kDarkBackground,
                    ),
                    const Text('Remember Me', style: TextStyle(color: kLightTextSecondary)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.forgotPassword),
                      child: const Text('Lupa Password?'),
                    ),
                  ],
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                          color: kSemanticError,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Masuk'),
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?', style: TextStyle(color: kLightTextSecondary)),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.register),
                      child: const Text('Daftar di sini'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}