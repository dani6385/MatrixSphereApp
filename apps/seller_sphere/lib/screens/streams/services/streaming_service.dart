import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class StreamingService {
  CameraController? _cameraController;
  Future<void> initializeCamera(bool useFrontCamera) async {
    // 1. Dapatkan daftar kamera yang tersedia di perangkat.
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('Tidak ada kamera yang ditemukan di perangkat ini.');
    }
    CameraDescription selectedCamera;

    try {
      // 2. Cari kamera yang sesuai dengan parameter 'useFrontCamera'.
      // Gunakan firstWhere untuk menemukan kamera dengan arah lensa (lensDirection) yang diinginkan.
      selectedCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            (useFrontCamera
                ? CameraLensDirection.front // Jika true, cari kamera depan
                : CameraLensDirection.back), // Jika false, cari kamera belakang
      );
    } catch (e) {
      // 3. Fallback: Jika kamera yang diinginkan (misal: depan) tidak ditemukan,
      //    gunakan kamera pertama yang tersedia (biasanya belakang) untuk mencegah crash.
      debugPrint(
          'Kamera yang diinginkan tidak ditemukan, menggunakan kamera pertama yang tersedia. Error: $e');
      selectedCamera = cameras.first;
    }

    // 4. Buat dan inisialisasi CameraController dengan kamera yang sudah dipilih.
    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high, // Atur resolusi sesuai kebutuhan
      enableAudio: true,
    );

    // 5. Inisialisasi controller. Ini akan menampilkan preview kamera.
    await _cameraController!.initialize();
  }

  // ... metode lainnya seperti switchCamera, dispose, dll.
  Future<void> switchCamera() async {
    if (_cameraController == null) return;

    // Dapatkan deskripsi kamera saat ini
    final currentLensDirection = _cameraController!.description.lensDirection;

    // Tentukan arah lensa yang berlawanan
    final newLensDirection = currentLensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    final cameras = await availableCameras();
    try {
      final newCamera =
          cameras.firstWhere((c) => c.lensDirection == newLensDirection);

      // Buang controller lama dan buat yang baru
      await _cameraController!.dispose();
      _cameraController = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
    } catch (e) {
      debugPrint("Gagal beralih kamera: $e");
    }
  }

  late ApiVideoLiveStreamController _controller;
  void dispose() {
    _cameraController?.dispose();
    // ... dispose resource lainnya
  }

  ApiVideoLiveStreamController get controller => _controller;

  void initController({
    required VoidCallback onConnectionSuccess,
    required Function(String) onConnectionFailed,
    required VoidCallback onDisconnected,
  }) {
    _controller = ApiVideoLiveStreamController(
      onConnectionSuccess: onConnectionSuccess,
      onConnectionFailed: onConnectionFailed,
      onDisconnection: onDisconnected,
      initialAudioConfig: AudioConfig(
        bitrate: 128 * 1024,
      ),
      initialVideoConfig: VideoConfig(
        resolution: Resolution.RESOLUTION_720,
        fps: 30,
        bitrate: 2 * 1024 * 1024,
      ),
    );
  }

  Future<void> initializeLiveStreamCamera(bool isFrontCamera) async {
    await _controller.initialize();
    // Note: Configuration is handled in the constructor for apivideo_live_stream.
    // If you need to change camera, use switchCamera() or set initialCamera in constructor.
  }

  Future<void> startStream(String url, String streamKey) async {
    await _controller.startStreaming(
      streamKey: streamKey,
      url: url,
    );
  }

  Future<void> stopStream() async {
    await _controller.stopStreaming();
  }

  Future<void> switchLiveStreamCamera() async {
    await _controller.switchCamera();
  }

  void toggleMute() {
    _controller.toggleMute();
  }

  Future<void> disposeLiveStreamController() async {
    try {
      if (await _controller.isStreaming) {
        await _controller.stopStreaming();
      }
      _controller.dispose();
    } catch (_) {}
  }
}
