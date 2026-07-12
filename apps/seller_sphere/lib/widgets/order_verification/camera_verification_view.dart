import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/shopsphere_order.dart';

class CameraVerificationView extends StatelessWidget {
  final ShopsphereOrder order;
  final Function(String) onBarcodeDetected;

  const CameraVerificationView({
    super.key,
    required this.order,
    required this.onBarcodeDetected,
  });

  @override
  Widget build(BuildContext context) {
    // This is a placeholder. A real implementation would use a camera package.
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kNeonCyan, width: 2)
          ),
          child: const Center(child: Icon(Icons.camera_alt, color: Colors.white, size: 50)),
        ),
        const SizedBox(height: 8),
        const Text(
          "Arahkan kamera ke barcode/QR Code pembeli.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: kNeonCyan),
        ),
        const SizedBox(height: 8),
        const Text(
          "(Camera preview requires 'mobile_scanner' package or similar)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9, color: Colors.grey),
        ),
      ],
    );
  }
}
