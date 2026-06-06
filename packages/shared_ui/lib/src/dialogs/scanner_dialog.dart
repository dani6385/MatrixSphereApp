import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

void showQRScanner(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Scan QRIS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    debugPrint("Hasil Scan: ${barcodes.first.rawValue}");
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ],
        ),
      );
    },
  );
}

Future<void> scanFromGallery(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final MobileScannerController controller = MobileScannerController();
    final BarcodeCapture? capture = await controller.analyzeImage(image.path);

    if (capture != null && capture.barcodes.isNotEmpty) {
      final String? code = capture.barcodes.first.rawValue;
      debugPrint("Hasil Scan dari Galeri: $code");
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      debugPrint("QR Code tidak ditemukan di gambar.");
    }
  }
}