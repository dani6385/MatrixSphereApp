import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:shared_ui/shared_ui.dart';

/// A screen for scanning barcodes or QR codes to identify products.
///
/// This screen uses the device's camera to detect a code. Once a code is
/// successfully detected, it pops the navigation stack and returns the
/// scanned code as a string result.
class LabelScannerScreen extends StatefulWidget {
  const LabelScannerScreen({super.key});

  @override
  State<LabelScannerScreen> createState() => _LabelScannerScreenState();
}

class _LabelScannerScreenState extends State<LabelScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  final TextEditingController _manualInputController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    _manualInputController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      setState(() {
        _isProcessing = true;
      });
      // Vibrate or play a sound to give feedback
      HapticFeedback.mediumImpact();

      // Return the scanned code to the previous screen
      Navigator.of(context).pop(code);
    }
  }

  void _submitManualSku() {
    final code = _manualInputController.text.trim();
    if (code.isNotEmpty) {
      // Return the manually entered code
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pindai Kode Produk'),
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: kNeonCyan);
                }
              },
            ),
            iconSize: 24.0,
            onPressed: () => _scannerController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flip_camera_ios),
            iconSize: 24.0,
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            // The scanner will stop when a barcode is detected
            onScannerStarted: (args) {
              setState(() {
                _isProcessing = false;
              });
            },
          ),
          // UI Overlay
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Scanning Area Box
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Instruction Text
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Posisikan kode di dalam kotak atau input manual',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Manual Input Section
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                color: Colors.black.withValues(alpha: 0.7),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _manualInputController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Input SKU Manual',
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: (_) => _submitManualSku(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(onPressed: _submitManualSku, icon: const Icon(Icons.send), style: IconButton.styleFrom(backgroundColor: kNeonCyan)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}