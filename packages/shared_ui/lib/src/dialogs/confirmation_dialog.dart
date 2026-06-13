import 'package:flutter/material.dart';

// Dialog konfirmasi umum
// Mengembalikan `true` jika ditekan Ya, `false` jika ditekan Tidak/Batal
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Ya',
  String cancelText = 'Batal',
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(false); // Kembalikan false
            },
          ),
          ElevatedButton(
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(true); // Kembalikan true
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false); // Jika dialog ditutup (misal, tekan back), anggap false
}
