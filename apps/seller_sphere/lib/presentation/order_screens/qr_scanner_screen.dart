import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Layar untuk memindai QR code verifikasi pesanan.
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      setState(() {
        _isProcessing = true;
      });
      // Hentikan kamera
      _scannerController.stop();
      // Kembali ke layar sebelumnya dengan membawa data kode
      context.pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pindai Kode QR Pembeli')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),
          // Overlay untuk area pemindaian
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Tombol untuk kontrol senter
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                color: Colors.white,
                // PERBAIKAN: Dengarkan _scannerController secara langsung
                icon: ValueListenableBuilder<MobileScannerState>(
                  valueListenable: _scannerController,
                  builder: (context, state, child) {
                    // Akses torchState dari objek 'state'
                    switch (state.torchState) {
                      case TorchState.on:
                        return const Icon(Icons.flash_on, color: Colors.yellow);
                      case TorchState.off:
                      default:
                        return const Icon(Icons.flash_off, color: Colors.white);
                    }
                  },
                ),
                iconSize: 32.0,
                onPressed: () => _scannerController.toggleTorch(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}