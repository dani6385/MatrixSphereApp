import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/foundation.dart';

class StreamingService {
  late ApiVideoLiveStreamController _controller;
  String _requestedCamera = 'front';

  // Tambahkan getter agar UI bisa mengakses controller yang sama
  ApiVideoLiveStreamController get controller => _controller;

  void initController({
    required VoidCallback onConnectionSuccess,
    required Function(String) onConnectionFailed,
    required VoidCallback onDisconnected,
    String initialCamera = 'front', // Ubah default ke kamera depan
  }) {
    _requestedCamera = initialCamera;
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
        bitrate: 1 *
            1024 *
            1024, // Turunkan sedikit untuk stabilitas di jaringan seluler
      ),
    );
  }

  Future<void> initializeCamera() async {
    // Pastikan ini dipanggil dan di-await sebelum preview ditampilkan
    await _controller.initialize();

    // Karena versi library ini mungkin tidak mendukung initialCamera di constructor,
    // kita lakukan switch secara manual jika yang diminta adalah kamera depan.
    if (_requestedCamera == 'front') {
      await _controller.switchCamera();
    }
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

  Future<void> switchCamera() async {
    await _controller.switchCamera();
  }

  void toggleMute() {
    _controller.toggleMute();
  }

  void dispose() {
    try {
      _controller.dispose();
    } catch (_) {}
  }
}
