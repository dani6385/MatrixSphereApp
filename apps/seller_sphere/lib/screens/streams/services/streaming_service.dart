import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/foundation.dart';

class StreamingService {
  late ApiVideoLiveStreamController _controller;

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

  Future<void> initializeCamera(bool isFrontCamera) async {
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

  Future<void> switchCamera() async {
    await _controller.switchCamera();
  }

  void toggleMute() {
    _controller.toggleMute();
  }

  Future<void> dispose() async {
    try {
      if (await _controller.isStreaming) {
        _controller.stopStreaming();
      }
    } catch (_) {}
  }
}
