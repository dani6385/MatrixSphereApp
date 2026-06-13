
import 'package:flutter/material.dart';

// Dialog untuk memasukkan kode voucher
Future<String?> showVoucherDialog(BuildContext context) {
  final TextEditingController voucherController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Gunakan Voucher'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: voucherController,
            decoration: const InputDecoration(
              labelText: 'Kode Voucher',
              hintText: 'Masukkan kode...',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kode tidak boleh kosong';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.pop(context, null); // Tutup dialog, kembalikan null
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
