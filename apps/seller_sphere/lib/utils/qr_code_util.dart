import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_ui/shared_ui.dart';

class QrCodeUtil {
  /// Generates a QR code widget for the given text.
  ///
  /// Returns a [QrImageView] widget which can be directly used in the UI.
  static Widget generateQrCodeWidget({
    required String text,
    double size = 200.0,
  }) {
    if (text.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: Text(
            "No data for QR Code",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      );
    }

    return QrImageView(
      data: text,
      version: QrVersions.auto,
      size: size,
      backgroundColor: kDarkBackground,
      gapless: false, // Recommended to be false for better compatibility
      errorStateBuilder: (cxt, err) {
        return SizedBox(
          width: size,
          height: size,
          child: const Center(
            child: Text(
              "Uh oh! Something went wrong...",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
