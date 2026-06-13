import 'package:flutter/material.dart';

// Model untuk mengembalikan hasil dari dialog
class MemberLoginDetails {
  final String username;
  final String password;

  MemberLoginDetails(this.username, this.password);
}

// Dialog untuk memasukkan username dan password member
Future<MemberLoginDetails?> showMemberDialog(BuildContext context) {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<MemberLoginDetails>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Login Member'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Masukkan username...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final details = MemberLoginDetails(
                  usernameController.text,
                  passwordController.text,
                );
                Navigator.pop(context, details);
              }
            },
          ),
        ],
      );
    },
  );
}
