import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../../routes/app_routes.dart';

class ScanQrTabWidget extends StatefulWidget {
  const ScanQrTabWidget({super.key});

  @override
  State<ScanQrTabWidget> createState() => _ScanQrTabWidgetState();
}

class _ScanQrTabWidgetState extends State<ScanQrTabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;
  bool _isScanning = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  Future<void> _simulateScan() async {
    setState(() {
      _isScanning = true;
      _isLoading = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isScanning = false;
        _isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        context.go(AppRoutes.homeScreen);
      }
    }
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
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isScanning ? AppTheme.primary : const Color(0xFFDDDDDD),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Corner markers
                ..._buildCorners(),
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _scanLineController,
                    builder: (context, _) {
                      return Positioned(
                        top: 20 + (_scanLineController.value * 160),
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppTheme.primary,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Center(
                  child: _isScanning
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 48,
                              color: Color(0xFF00897B),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Memindai...',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        )
                      : Column(
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
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: (_isScanning || _isLoading) ? null : _simulateScan,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                    ),
              label: Text(
                _isScanning
                    ? 'Memindai QR...'
                    : _isLoading
                    ? 'Memproses...'
                    : 'Buka Kamera & Scan',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
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

  List<Widget> _buildCorners() {
    const color = AppTheme.primary;
    const size = 20.0;
    const thickness = 3.0;
    return [
      // Top-left
      Positioned(
        top: 12,
        left: 12,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: thickness),
              left: BorderSide(color: color, width: thickness),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 12,
        right: 12,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: thickness),
              right: BorderSide(color: color, width: thickness),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 12,
        left: 12,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: thickness),
              left: BorderSide(color: color, width: thickness),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 12,
        right: 12,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: thickness),
              right: BorderSide(color: color, width: thickness),
            ),
          ),
        ),
      ),
    ];
  }
}
