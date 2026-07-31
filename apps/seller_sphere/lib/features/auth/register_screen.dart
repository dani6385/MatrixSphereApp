import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _shopNameController = TextEditingController();

  int _currentStep = 0;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  User? _createdUser;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _handleNextStep() async {
    if (_currentStep == 0) {
      // Validasi form langkah 1 (Pendaftaran Akun)
      if (_formKeyStep1.currentState!.validate()) {
        setState(() => _isLoading = true);
        try {
          final userCredential = await _authService.createUserAccount(
            _emailController.text.trim(),
            _passwordController.text,
          );
          _createdUser = userCredential.user;
          if (_createdUser != null) {
            setState(() => _currentStep++);
          } else {
            _showError("Gagal membuat akun, coba lagi.");
          }
        } catch (e) {
          _showError(e.toString());
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleRegister() async {
    // Validasi form langkah 2 (Pendaftaran Toko)
    if (_formKeyStep2.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (_createdUser == null) {
          throw Exception("Sesi pengguna tidak valid, silakan mulai lagi.");
        }
        await _authService.registerShop(
          user: _createdUser!,
          shopName: _shopNameController.text.trim(),
        );

        if (mounted) {
          showInfoDialog(
            context: context,
            title: 'Registrasi Berhasil',
            message:
                'Akun dan toko Anda telah berhasil dibuat. Silakan login untuk melanjutkan.',
            buttonText: 'Login', onPressed: () {  },
          );
          // Arahkan ke halaman login setelah dialog ditutup
          context.go(AppRoutes.login);
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      showErrorDialog(context: context, message: message.replaceAll("Exception: ", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Penjual'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _currentStep--),
              )
            : null,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) {
          if (step < _currentStep) {
            setState(() => _currentStep = step);
          }
        },
        controlsBuilder: (context, details) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      if (_currentStep == 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleNextStep,
                            child: const Text('Lanjut'),
                          ),
                        ),
                      if (_currentStep == 1)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleRegister,
                            child: const Text('Daftar'),
                          ),
                        ),
                    ],
                  ),
                );
        },
        steps: [
          Step(
            title: const Text('Akun'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKeyStep1,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value == null || !value.contains('@'))
                        ? 'Masukkan email yang valid'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) => (value == null || value.length < 6)
                        ? 'Password minimal 6 karakter'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) => (value != _passwordController.text)
                        ? 'Password tidak cocok'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Toko'),
            isActive: _currentStep >= 1,
            content: Form(
              key: _formKeyStep2,
              child: Column(
                children: [
                  TextFormField(
                    controller: _shopNameController,
                    decoration: const InputDecoration(labelText: 'Nama Toko'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Nama toko tidak boleh kosong'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}