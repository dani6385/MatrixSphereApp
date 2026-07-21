import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceCamera extends StatefulWidget {
  final CameraController? controller;
  final void Function(XFile? image) onPictureTaken;

  const AttendanceCamera({
    super.key,
    required this.controller,
    required this.onPictureTaken, required Null Function(CameraController? p1) onControllerCreated,
  });

  @override
  State<AttendanceCamera> createState() => _AttendanceCameraState();
}

class _AttendanceCameraState extends State<AttendanceCamera> {
  Future<void>? _initializeControllerFuture;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi hanya jika controller tersedia
    if (widget.controller != null) {
      _initializeControllerFuture = widget.controller!.initialize();
    }
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture || widget.controller == null || !widget.controller!.value.isInitialized) {
      return;
    }
    setState(() => _isTakingPicture = true);
    try {
      final image = await widget.controller!.takePicture();
      widget.onPictureTaken(image);
    } catch (e) {
      debugPrint("Error taking picture: $e");
      widget.onPictureTaken(null);
    } finally {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (widget.controller == null || !widget.controller!.value.isInitialized) {
            return const Center(child: Text('Kamera tidak tersedia.', style: TextStyle(color: kDarkTextSecondary)));
          }
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(widget.controller!),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                onPressed: _takePicture,
                backgroundColor: kBrandPrimary,
                child: _isTakingPicture
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
