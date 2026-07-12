import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScanner extends StatefulWidget {
  final Function(String) onBarcodeDetected;
  final Function(String) onError;

  const CameraScanner(
      {super.key, required this.onBarcodeDetected, required this.onError});

  @override
  CameraScannerState createState() => CameraScannerState();
}

class CameraScannerState extends State<CameraScanner> {
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraPermissionStatus = status;
    });
    if (status.isGranted) {
      _initializeCamera();
    } else {
      widget.onError("Izin Kamera diperlukan.");
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      widget.onError("Kamera tidak ditemukan.");
      return;
    }
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});

      _cameraController!.startImageStream((image) {
        if (_isProcessing) return;
        _isProcessing = true;
        _processImage(image);
      });
    } catch (e) {
      widget.onError("Gagal memulai kamera: ${e.toString()}");
    }
  }

  void _processImage(CameraImage image) async {
    final inputImage = InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotationValue.fromRawValue(
            _cameraController?.description.sensorOrientation ?? 0)!,
        format:
            InputImageFormatValue.fromRawValue(image.format.raw) ??
                InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );

    try {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      for (final barcode in barcodes) {
        if (barcode.rawValue != null) {
          widget.onBarcodeDetected(barcode.rawValue!);
          // Stop further processing
          _cameraController?.stopImageStream();
          return;
        }
      }
    } catch (e) {
      // Errors are frequent, so we might not want to show all of them.
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraPermissionStatus.isGranted) {
      return Column(
        children: [
          const Text("Izin kamera dibutuhkan untuk memindai."),
          ElevatedButton(
            onPressed: _requestCameraPermission,
            child: const Text("Berikan Izin"),
          ),
        ],
      );
    }
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(_cameraController!),
            // Add scanner overlay UI here if needed (e.g., border, laser line)
            CustomPaint(
              size: const Size(double.infinity, 180),
              painter: ScannerOverlayPainter(),
            )
          ],
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    const cornerLength = 20.0;
    const padding = 15.0;
    final rectHeight = size.height - (padding * 2);
    final rectWidth = rectHeight;
    final left = (size.width - rectWidth) / 2;
    final top = padding;
    final right = left + rectWidth;
    final bottom = top + rectHeight;

    // Top-left
    canvas.drawLine(
        Offset(left, top), Offset(left + cornerLength, top), paint);
    canvas.drawLine(
        Offset(left, top), Offset(left, top + cornerLength), paint);
    // Top-right
    canvas.drawLine(
        Offset(right, top), Offset(right - cornerLength, top), paint);
    canvas.drawLine(
        Offset(right, top), Offset(right, top + cornerLength), paint);
    // Bottom-left
    canvas.drawLine(
        Offset(left, bottom), Offset(left + cornerLength, bottom), paint);
    canvas.drawLine(
        Offset(left, bottom), Offset(left, bottom - cornerLength), paint);
    // Bottom-right
    canvas.drawLine(
        Offset(right, bottom), Offset(right - cornerLength, bottom), paint);
    canvas.drawLine(
        Offset(right, bottom), Offset(right, bottom - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}