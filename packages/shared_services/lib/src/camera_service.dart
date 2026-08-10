import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

/// A result class to hold the outcome of the camera initialization process.
class CameraInitializationResult {
  final CameraController? controller;
  final Future<void>? initializeFuture;
  final bool permissionGranted;

  CameraInitializationResult({
    this.controller,
    this.initializeFuture,
    required this.permissionGranted,
  });
}

/// A service class to handle all camera-related functionalities.
class CameraService {
  CameraController? _controller;

  /// Initializes the front camera and handles permissions.
  ///
  /// This method requests camera permission if not already granted,
  /// finds the front-facing camera, and prepares the [CameraController].
  Future<CameraInitializationResult> initializeCamera() async {
    // 1. Handle camera permission.
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (!status.isGranted) {
      // Return early if permission is denied.
      return CameraInitializationResult(permissionGranted: false);
    }

    // 2. Initialize camera if permission is granted.
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      // Return if no cameras are available on the device.
      return CameraInitializationResult(permissionGranted: true);
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    // Dispose the old controller to avoid memory leaks.
    _controller?.dispose();

    _controller = CameraController(frontCamera, ResolutionPreset.high, enableAudio: false);
    final initializeFuture = _controller!.initialize();

    return CameraInitializationResult(
      controller: _controller,
      initializeFuture: initializeFuture,
      permissionGranted: true,
    );
  }

  /// Disposes the camera controller when it's no longer needed.
  void dispose() {
    _controller?.dispose();
  }
}