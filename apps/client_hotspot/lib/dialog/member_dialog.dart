import 'package:flutter/material.dart';

/// Menampilkan dialog untuk login member.
///
/// Mengembalikan `Map<String, String>` yang berisi 'username' dan 'password' jika login ditekan,
/// atau `null` jika dialog dibatalkan.
Future<Map<String, String>?> showMemberLoginDialog(BuildContext context, [Future<void> Function({String password, required String username})? handleLogin]) {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  return showDialog<Map<String, String>?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login Member'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
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
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              // Tutup dialog dan tidak mengembalikan apa-apa
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                // Tutup dialog dan kembalikan data login
                Navigator.pop(context, {
                  'username': usernameController.text,
                  'password': passwordController.text,
                });
              }
            },
          ),
        ],
      );
    },
  );
}
