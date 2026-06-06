import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatelessWidget {
  final MobileScannerController cameraController = MobileScannerController();

  ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QRIS")),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            print("Hasil Scan: ${barcodes.first.rawValue}");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Buka Galeri
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
          
          if (image != null) {
            // Scan gambar dari galeri
            await cameraController.analyzeImage(image.path);
          }
        },
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}