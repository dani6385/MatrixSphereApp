import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _isProcessing = false;
  bool _isTorchOn = false;
  CameraFacing _cameraFacing = CameraFacing.back;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          _isProcessing = true;
        });
        // Kembali ke layar sebelumnya dengan hasil scan
        Navigator.of(context).pop(code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await _scannerController.toggleTorch();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
            tooltip: 'Toggle Torch',
          ),
          IconButton(
            icon: Icon(_cameraFacing == CameraFacing.front
                ? Icons.camera_front
                : Icons.camera_rear),
            onPressed: () async {
              await _scannerController.switchCamera();
              setState(() {
                _cameraFacing = _cameraFacing == CameraFacing.front
                    ? CameraFacing.back
                    : CameraFacing.front;
              });
            },
            tooltip: 'Switch Camera',
          ),
        ],
      ),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: _onDetect,
      ),
    );
  }
}