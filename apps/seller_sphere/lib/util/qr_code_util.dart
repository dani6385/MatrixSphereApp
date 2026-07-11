import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeUtil {
  /// Generates a QR code widget for the given text.
  ///
  /// Returns a [QrImageView] widget if the text is not empty,
  /// otherwise returns a placeholder container.
  static Widget generateQrCodeWidget({
    required String text,
    double size = 200.0,
  }) {
    if (text.isEmpty) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey[300],
        child: const Center(
          child: Text('No data', style: TextStyle(color: Colors.black54)),
        ),
      );
    }
    return QrImageView(
      data: text,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
    );
  }
}