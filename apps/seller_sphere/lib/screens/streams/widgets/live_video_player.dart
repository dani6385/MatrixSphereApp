import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Widget untuk menampilkan pratinjau kamera streamer.
///
/// Ini adalah StatefulWidget karena perlu mengelola siklus hidup
/// dari CameraController.
class LiveVideoPlayer extends StatefulWidget {
  const LiveVideoPlayer({super.key});

  @override
  State<LiveVideoPlayer> createState() => _LiveVideoPlayerState();
}

class _LiveVideoPlayerState extends State<LiveVideoPlayer> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // 1. Dapatkan daftar kamera yang tersedia.
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        debugPrint("Tidak ada kamera yang ditemukan.");
        return;
      }

      // 2. Inisialisasi controller dengan kamera depan (biasanya index 1).
      // Gunakan _cameras![0] untuk kamera belakang.
      _controller = CameraController(_cameras![1], ResolutionPreset.high);

      await _controller!.initialize();

      // 3. Perbarui state untuk membangun ulang UI dengan pratinjau kamera.
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error saat inisialisasi kamera: $e");
    }
  }

  @override
  void dispose() {
    // 4. Pastikan untuk melepaskan controller saat widget dihancurkan.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      // Tampilkan loading indicator saat kamera sedang diinisialisasi.
      return const Center(child: CircularProgressIndicator());
    }
    // Tampilkan pratinjau kamera jika sudah siap.
    return CameraPreview(_controller!);
  }
}