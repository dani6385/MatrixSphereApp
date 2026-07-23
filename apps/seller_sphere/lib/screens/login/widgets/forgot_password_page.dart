import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/auth/auth_bloc.dart';
import 'package:shared_ui/shared_ui.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      context
          .read<AuthBloc>()
          .add(PasswordResetRequested(email: email) as AuthEvent);

      // Tampilkan dialog konfirmasi
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Tautan Terkirim'),
          content: Text(
              'Jika akun dengan email $email terdaftar, kami telah mengirimkan tautan untuk mengatur ulang kata sandi Anda.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog
                context.pop(); // Kembali ke halaman login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: kBrandTertiary,
      ),
      backgroundColor: kBrandTertiary,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Masukkan email Anda untuk menerima tautan atur ulang password.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'Masukkan email yang valid'
                    : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: _sendResetLink, child: const Text('Kirim Tautan')),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordResetRequested {
  final String email;

  const PasswordResetRequested({required this.email});
}
