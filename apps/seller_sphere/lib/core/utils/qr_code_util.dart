import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_ui/shared_ui.dart';

/// Widget pembantu untuk menampilkan QR Code berdasarkan data teks yang diberikan.
class QrCodeUtil extends StatelessWidget {
  final String data;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const QrCodeUtil({
    Key? key,
    required this.data,
    this.size = 200.0,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Jika data kosong, tampilkan pesan peringatan sederhana
    if (data.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: Text(
            "Data QR Kosong",
            style: TextStyle(color: kDarkTextSecondary, fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size - 16, // Menyesuaikan dengan padding kontainer
        // Anda dapat mengatur warna modul QR jika diperlukan
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: color ?? kDarkSecondary,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: color ?? kDarkSecondary,
        ),
      ),
    );
  }
}