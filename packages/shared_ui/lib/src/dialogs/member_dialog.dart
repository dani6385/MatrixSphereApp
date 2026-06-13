import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MemberDialog extends StatefulWidget {
  const MemberDialog({super.key});

  @override
  State<MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      final credentials = {
        "username": _usernameController.text,
        "password": _passwordController.text,
      };

      logger.i("Mencoba autentikasi member: ${_usernameController.text}");

      // Mengembalikan data ke LoginScreen untuk diproses oleh MikrotikService.login
      Navigator.pop(context, credentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Member'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Masukkan username' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Masukkan password' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submitLogin,
          child: const Text('Login'),
        ),
      ],
    );
  }
}
Future<Map<String, String>?> showMemberDialog(BuildContext context) {
  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) => const MemberDialog(),
  );
}