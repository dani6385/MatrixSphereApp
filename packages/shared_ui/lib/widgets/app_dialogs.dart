import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Menampilkan dialog standar untuk pesan kesalahan.
///
/// Dialog ini memiliki judul default 'Terjadi Kesalahan' dan tombol 'OK'.
///
/// [context]: BuildContext dari widget yang memanggil.
/// [message]: Pesan error yang ingin ditampilkan.
/// [title]: Judul dialog, defaultnya adalah 'Terjadi Kesalahan'.
void showErrorDialog({
  required BuildContext context,
  required String message,
  String title = 'Terjadi Kesalahan',
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: kAlertRed, // Memberi warna merah untuk menegaskan
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Menampilkan dialog standar untuk informasi (helper popup).
///
/// Dialog ini digunakan untuk memberikan informasi, konfirmasi sukses, atau peringatan ringan.
///
/// [context]: BuildContext dari widget yang memanggil.
/// [title]: Judul dialog.
/// [message]: Pesan yang ingin ditampilkan.
/// [buttonText]: Teks untuk tombol aksi, defaultnya adalah 'Mengerti'.
void showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'Mengerti', required Null Function() onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(buttonText),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Menampilkan SnackBar untuk pesan informasi singkat yang hilang otomatis.
///
/// Ini berguna untuk notifikasi yang tidak memerlukan interaksi pengguna,
/// seperti "Berhasil disimpan" atau "Item ditambahkan".
///
/// [context]: BuildContext dari widget yang memanggil.
/// [message]: Pesan yang ingin ditampilkan.
/// [duration]: Durasi tampilan SnackBar, defaultnya adalah 3 detik.
void showInfoSnackBar({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  // Hapus SnackBar yang mungkin sedang aktif untuk menghindari tumpukan.
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // Tampilkan SnackBar baru.
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
    ),
  );
}