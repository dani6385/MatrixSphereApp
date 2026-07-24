import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  /// Memuat email dan status "Ingat Saya" dari SharedPreferences saat widget diinisialisasi.
  void _loadUserEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('remember_me_email');
      final bool? rememberMe = prefs.getBool('remember_me_status');

      if (rememberMe != null && rememberMe && email != null) {
        setState(() {
          _emailController.text = email;
          _rememberMe = rememberMe;
        });
      }
    } catch (e) {
      debugPrint("Error loading from SharedPreferences: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Menyimpan atau menghapus preferensi "Ingat Saya" di SharedPreferences.
  void _handleRememberMe() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('remember_me_email', _emailController.text.trim());
        await prefs.setBool('remember_me_status', true);
      } else {
        await prefs.remove('remember_me_email');
        await prefs.remove('remember_me_status');
      }
    } catch (e) {
      debugPrint("Error saving to SharedPreferences: $e");
    }
  }

  void _onLoginPressed() {
    // Jalankan validasi form sebelum mengirim request
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Kirim event login ke AuthBloc
      context.read<AuthBloc>().add(
            AuthLoginRequested(email: email, password: password),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Jika login berhasil, proses logika "Ingat Saya".
          _handleRememberMe();
        }
        // Tampilkan SnackBar jika terjadi error saat login
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(context),
                  const SizedBox(height: 40),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  _buildRememberMeCheckbox(),
                  _buildForgotPasswordButton(),
                  const SizedBox(height: 24),
                  _buildLoginButton(state),
                  const SizedBox(height: 16),
                  _buildRegisterNavigation(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Ganti dengan path logo Anda jika ada
        // Image.asset('assets/images/logo.png', height: 100),
        const Icon(Icons.store, size: 80, color: kBrandPrimary),
        const SizedBox(height: 30),
        Text(
          'Selamat Datang Kembali!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: kBrandBlack,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masuk untuk mengelola toko Anda.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Masukkan format email yang valid';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (bool? value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
        ),
        const Text('Ingat Saya'),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.push('/forgot-password'),
        child: const Text('Lupa Password?'),
      ),
    );
  }

  Widget _buildLoginButton(AuthState state) {
    return ElevatedButton(
      onPressed: state is AuthLoading ? null : _onLoginPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kBrandPrimary,
        foregroundColor: kBrandWhite,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: state is AuthLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Login', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildRegisterNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Belum punya akun?'),
        TextButton(
          onPressed: () => context.push('/register'),
          child: const Text(
            'Daftar Sekarang',
            style: TextStyle(
              color: kBrandPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
