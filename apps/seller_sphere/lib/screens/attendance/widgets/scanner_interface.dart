import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ScannerInterface extends StatelessWidget {
  final bool hasCameraPermission;
  final CameraController? cameraController;
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;

  const ScannerInterface({
    super.key,
    required this.hasCameraPermission,
    required this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: kNeonCyan.withValues(alpha: 0.8), width: 2),
      ),
      color: const Color(0xFF0F172A),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 350,
        child: Stack(
          children: [
            if (hasCameraPermission &&
                cameraController != null &&
                cameraController!.value.isInitialized)
              _buildCameraPreview()
            else
              _buildPermissionRequestView(context),
            _buildScannerOverlay(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildScanProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Center(
      child: AspectRatio(
        aspectRatio: cameraController!.value.aspectRatio,
        child: CameraPreview(cameraController!),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Oval Outline
          Container(
            width: 240,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(color: kNeonCyan, width: 1.5),
              borderRadius: BorderRadius.circular(140),
            ),
          ),
          // Glowing scan line
          AnimatedBuilder(
            animation: laserAnimation,
            builder: (context, child) {
              return Positioned(
                top: 280 * laserAnimation.value,
                child: Container(
                  width: 240 * 0.8,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kNeonCyan,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        color: kNeonCyan,
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequestView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off,
              color: Theme.of(context).colorScheme.error, size: 48),
          const SizedBox(height: 16),
          const Text(
            "Izin Kamera Dibutuhkan",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "Kamera depan diperlukan untuk memverifikasi wajah biometrik Anda secara langsung.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRequestPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: kNeonCyan,
              foregroundColor: Colors.black,
            ),
            child: const Text("Berikan Izin Kamera"),
          ),
        ],
      ),
    );
  }

  Widget _buildScanProgressIndicator() {
    return Container(
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.7),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            scanStatusMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: scanProgress,
            backgroundColor: Colors.grey[800],
            color: kNeonCyan,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onCancelScan,
            child: const Text(
              "Batalkan Pemindaian",
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}