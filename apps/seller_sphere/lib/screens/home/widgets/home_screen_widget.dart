import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeScannerWidget extends StatelessWidget {
  const HomeScannerWidget({
    super.key,
    required this.isScanning,
    required this.hasCameraPermission,
    required this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
  });

  final bool isScanning;
  final bool hasCameraPermission;
  final CameraController?
      cameraController; // Menggunakan tipe CameraController yang spesifik dan nullable
  final Animation<double>
      laserAnimation; // Menggunakan tipe Animation<double> yang spesifik
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hasCameraPermission)
          Column(
            children: [
              const Text(
                'Akses kamera diperlukan untuk memindai.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRequestPermission,
                child: const Text('Izinkan Akses Kamera'),
              ),
            ],
          )
        else if (cameraController != null &&
            cameraController!.value.isInitialized)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
                    // Overlay untuk laser scan
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: laserAnimation,
                        builder: (context, child) {
                          return Align(
                            alignment: Alignment(0, laserAnimation.value * 2 - 1),
                            child: Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.red,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                scanStatusMessage,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: scanProgress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onCancelScan,
                child: const Text('Batalkan Pindai'),
              ),
            ],
          )
        else
          const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Memuat kamera...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class HomeActionButtons extends StatelessWidget {
  const HomeActionButtons({
    super.key,
    required this.isCheckingLocation,
    required this.onClockIn,
    required this.onClockOut,
  });

  final bool isCheckingLocation;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isCheckingLocation ? null : onClockIn,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: kSoftTeal,
            foregroundColor: kBrandWhite,
          ),
          child: isCheckingLocation
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Clock In'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isCheckingLocation ? null : onClockOut,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: kAlertRed,
            foregroundColor: kBrandWhite,
          ),
          child: isCheckingLocation
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Clock Out'),
        ),
      ],
    );
  }
}