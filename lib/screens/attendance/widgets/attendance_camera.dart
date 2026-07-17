import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AttendanceCamera extends StatefulWidget {
  final Function(CameraController?) onControllerCreated;

  const AttendanceCamera({
    super.key,
    required this.onControllerCreated, required Null Function(XFile? image) onPictureTaken,
  });

  @override
  State<AttendanceCamera> createState() => _AttendanceCameraState();
}

class _AttendanceCameraState extends State<AttendanceCamera> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController?.initialize();
    await _initializeControllerFuture;
    if (mounted) {
      widget.onControllerCreated(_cameraController);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(child: CameraPreview(_cameraController!));
  }
}