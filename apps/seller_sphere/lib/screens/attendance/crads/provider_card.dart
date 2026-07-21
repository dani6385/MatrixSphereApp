// lib/screens/Attendance/crads/provider_card.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../action/attendance_action.dart';
import '../content/attendance_camera.dart';
import '../providers/attendance_provider.dart';

class ProviderCard extends StatefulWidget {
  const ProviderCard({super.key});

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  bool _isCameraVisible = false;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("Tidak ada kamera yang ditemukan.");
        return;
      }
      final frontCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first);

      _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    } catch (e) {
      debugPrint("Gagal setup kamera: $e");
    }
  }

  void _handlePictureTaken(XFile? image) {
    if (image != null) {
      context.read<AttendanceProvider>().addAttendance(DateTime.now());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absensi berhasil direkam!')),
      );

      setState(() {
        _isCameraVisible = false; // Kembali menampilkan tombol tindakan
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Membaca status absensi ter-update dari Provider
    final attendanceProvider = context.watch<AttendanceProvider>();
    final isCheckedIn = attendanceProvider.isCheckedIn;
    final isCheckOutCompleted = attendanceProvider.isCheckOutCompleted;

    // KOREKSI UTAMA: Menghilangkan Padding, ListView, DateCard, dan MonthlyStats
    // agar kelas ini murni hanya merender Kamera ATAU Tombol Tindakan Absensi saja.
    if (_isCameraVisible) {
      return AttendanceCamera(
        controller: _cameraController,
        onPictureTaken: _handlePictureTaken,
        onControllerCreated: (p0) {},
      );
    }

    return AttendanceAction(
      isCheckedIn: isCheckedIn,
      isCheckOutCompleted: isCheckOutCompleted,
      onCheckIn: () => setState(() => _isCameraVisible = true),
      onCheckOut: () => setState(() => _isCameraVisible = true),
    );
  }
}