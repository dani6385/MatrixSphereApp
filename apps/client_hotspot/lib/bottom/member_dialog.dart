import 'package:flutter/material.dart';

// Mengembalikan parameter `onLogin` yang hilang untuk menangani logika login
void showMemberDialog(BuildContext context,
    Function({required String username, required String password}) onLogin) {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Login Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              autofocus: true,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Memanggil callback onLogin yang sudah dikembalikan
              onLogin(
                username: usernameController.text,
                password: passwordController.text,
              );
              // Proses selanjutnya (termasuk menutup dialog) akan ditangani oleh fungsi _handleLogin
            },
            child: const Text('Login'),
          ),
        ],
      );
    },
  );
}
