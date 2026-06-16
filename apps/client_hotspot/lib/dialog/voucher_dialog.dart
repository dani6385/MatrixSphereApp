import 'package:flutter/material.dart';

/// Menampilkan dialog untuk memasukkan kode voucher.
///
/// Mengembalikan kode voucher sebagai `String` jika login ditekan,
/// atau `null` jika dialog dibatalkan.
Future<String?> showVoucherDialog(BuildContext context, Future<void> Function({String password, required String username}) handleLogin) {
  final formKey = GlobalKey<FormState>();
  final voucherController = TextEditingController();

  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login Voucher'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: voucherController,
                decoration: const InputDecoration(labelText: 'Kode Voucher'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode voucher tidak boleh kosong';
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
                // Tutup dialog dan kembalikan kode voucher
                Navigator.pop(context, voucherController.text);
              }
            },
          ),
        ],
      );
    },
  );
}
