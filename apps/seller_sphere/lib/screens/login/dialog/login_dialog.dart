// TODO Implement this library.
import 'package:flutter/material.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Berhasil'),
      content: const Text('Anda telah berhasil masuk ke aplikasi.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
