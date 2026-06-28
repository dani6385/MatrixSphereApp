import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:client_hotspot/routes/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_ui/shared_ui.dart';

class ScanQrDialog extends StatefulWidget {
  const ScanQrDialog({super.key});

  @override
  State<ScanQrDialog> createState() => _ScanQrDialogState();
}

class _ScanQrDialogState extends State<ScanQrDialog> {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _isLoading = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isLoading) return;
    final String? code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isLoading = true);
    _cameraController.stop();
    await _processQrCode(code);
  }

  Future<void> _pickImageFromGallery() async {
    if (_isLoading) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null || !mounted) return;

    setState(() => _isLoading = true);
    final BarcodeCapture? capture = await _cameraController.analyzeImage(image.path);
    if (capture == null || !mounted) {
      Fluttertoast.showToast(msg: "Tidak ada QR Code yang ditemukan.");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processQrCode(String code) async {
    // Simulasi validasi kode dan login
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      context.go(AppRoutes.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Scan QR Code',
                  style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              MobileScanner(
                                controller: _cameraController,
                                onDetect: _onDetect,
                              ),
                              // Scanner Overlay
                              Container(
                                decoration: ShapeDecoration(
                                  shape: QrScannerOverlayShape(
                                    borderColor: AppTheme.primary,
                                    borderRadius: 12,
                                    borderLength: 24,
                                    borderWidth: 6,
                                    cutOutSize: 200,
                                  ),
                                ),
                              ),
                              if (_isLoading)
                                const Center(child: CircularProgressIndicator()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Arahkan kamera ke QR code untuk login otomatis.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _isLoading ? null : _pickImageFromGallery,
                        icon: const Icon(Icons.image_outlined, size: 20),
                        label: const Text('Pilih dari Galeri'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}