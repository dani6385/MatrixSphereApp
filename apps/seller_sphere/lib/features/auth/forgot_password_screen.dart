import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_services/auth/auth_service.dart';
import 'package:shared_ui/shared_ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _message = null;
      });

      try {
        await _authService.sendPasswordResetEmail(_emailController.text.trim());
        setState(() {
          _message =
              'Email reset password telah dikirim. Silakan periksa inbox Anda.';
          _isError = false;
        });
      } catch (e) {
        setState(() {
          _message = e.toString().replaceFirst('Exception: ', '');
          _isError = true;
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
    return PopScope(
      canPop: false, // Mencegah aplikasi langsung tertutup atau keluar
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        // Arahkan kembali ke halaman login saat tombol kembali ditekan
        context.go(AppRoutes.login);
      },
      child: Scaffold(
        backgroundColor: kDarkBackground,
        appBar: AppBar(
          title: const Text('Lupa Password'),
          backgroundColor: kDarkSecondary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(AppRoutes.login),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Masukkan email Anda untuk menerima link reset password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: kLightTextSecondary),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'Email tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 24),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _message!,
                      style: TextStyle(
                          color: _isError ? kSemanticError : kSemanticSuccess,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _sendResetEmail,
                        child: const Text('Kirim Email Reset')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
