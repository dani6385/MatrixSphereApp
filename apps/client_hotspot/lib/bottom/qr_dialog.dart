import 'package:flutter/material.dart';

/// Menampilkan dialog untuk memasukkan kode RQ.
///
/// Mengembalikan kode RQ sebagai \`String\` jika tombol "OK" ditekan,
/// atau \`null\` jika dialog dibatalkan.
Future<String?> showQrDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final rqCodeController = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Masukkan Kode RQ'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Silakan masukkan kode RQ Anda.'),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: rqCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Kode RQ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kode RQ tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(context).pop(); // Return null
            },
          ),
          FilledButton(
            child: const Text('OK'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(rqCodeController.text);
              }
            },
          ),
        ],
      );
    },
  );
}
