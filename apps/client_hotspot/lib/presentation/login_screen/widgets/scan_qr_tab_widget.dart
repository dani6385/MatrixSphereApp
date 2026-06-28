import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../routes/app_routes.dart';

class ScanQrTabWidget extends StatefulWidget {
  const ScanQrTabWidget({super.key});

  @override
  State<ScanQrTabWidget> createState() => _ScanQrTabWidgetState();
}

class _ScanQrTabWidgetState extends State<ScanQrTabWidget>
    {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _isLoading = false;
  bool _isCameraStarted = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _startCamera() {
    setState(() {
      _isCameraStarted = true;
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isLoading) return; // Mencegah deteksi berulang saat sedang proses

    final String? code = capture.barcodes.first.rawValue;

    if (code == null) {
      Fluttertoast.showToast(msg: "QR Code tidak valid.");
      return;
    }

    setState(() => _isLoading = true);
    _cameraController.stop(); // Hentikan kamera setelah kode terdeteksi

    // Di sini Anda akan memproses 'code' (misalnya, validasi ke server)
    // Untuk sekarang, kita simulasi proses dan langsung login
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) context.go(AppRoutes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          Text(
            'Arahkan kamera ke QR code voucher atau tiket akses',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 20),
          // QR Viewfinder mockup
          SizedBox(
            width: 220,
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _isCameraStarted
                  ? Stack(
                      children: [
                        MobileScanner(
                          controller: _cameraController,
                          onDetect: _onDetect,
                        ),
                        _buildScannerOverlay(),
                      ],
                    )
                  : _buildCameraPlaceholder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: _isCameraStarted
                ? FilledButton.icon(
                    onPressed: _isLoading ? null : () => _cameraController.stop(),
                    style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                    icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
                    label: Text('Hentikan Scan', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                  )
                : FilledButton.icon(
                    onPressed: _isLoading ? null : _startCamera,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
                    label: Text(
                      _isLoading ? 'Memproses...' : 'Buka Kamera & Scan',
                      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            'Pastikan QR code berada dalam area scan dan pencahayaan cukup',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              size: 64,
              color: const Color(0xFF9E9E9E).withAlpha(128),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol untuk\nmulai scan',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      decoration: ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: AppTheme.primary,
          borderRadius: 12,
          borderLength: 24,
          borderWidth: 6,
          cutOutSize: 200,
        ),
      ),
    );
  }
}

/// Helper class untuk menggambar overlay pada scanner.
/// Anda bisa memindahkan ini ke file terpisah jika diinginkan.
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = 0.8,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.top + borderLength)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + borderLength, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(
          rect.right - borderLength, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + borderLength)
      ..lineTo(rect.right, rect.bottom - borderLength)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right - borderLength, rect.bottom)
      ..lineTo(rect.left + borderLength, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.bottom - borderLength)
      ..lineTo(rect.left, rect.top + borderLength);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
