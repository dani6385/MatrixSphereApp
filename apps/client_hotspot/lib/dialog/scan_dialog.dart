import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Menampilkan dialog untuk memindai kode QR dari kamera atau galeri.
///
/// Mengembalikan kode QR sebagai `String` jika berhasil, atau `null` jika dibatalkan.
Future<String?> showScanDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _ScanDialog(),
  );
}

class _ScanDialog extends StatefulWidget {
  const _ScanDialog();

  @override
  State<_ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<_ScanDialog> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  final ImagePicker _picker = ImagePicker();
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    // Subscribe to barcode detection events
    _subscription = _scannerController.barcodes.listen(_handleBarcode);
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (mounted && capture.barcodes.isNotEmpty) {
      final String? code = capture.barcodes.first.rawValue;
      // Pop dialog with the scanned code
      Navigator.of(context).pop(code);
    }
  }

  Future<void> _scanImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return; // User cancelled the picker

      final BarcodeCapture? capture = await _scannerController.analyzeImage(image.path);

      if (!mounted) return;
      
      if (capture != null && capture.barcodes.isNotEmpty) {
        _handleBarcode(capture);
      } else {
        _showError('Tidak ada kode QR yang ditemukan di gambar.');
      }
    } catch (e) {
      _showError('Gagal memindai gambar: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
      // Close the dialog after showing the error
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Cancel the subscription and dispose the controller
    _subscription?.cancel();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pindai Kode QR'),
      content: SizedBox(
        width: 300,
        height: 350,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MobileScanner(
                  controller: _scannerController,
                  errorBuilder: (context, error, child) {
                    return Center(
                      child: Text(
                        'Kamera tidak tersedia atau terjadi kesalahan: \n${error.toString()}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Arahkan kamera ke kode QR',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(Icons.image_outlined),
          label: const Text('Dari Galeri'),
          onPressed: _scanImageFromGallery,
        ),
        TextButton(
          child: const Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
