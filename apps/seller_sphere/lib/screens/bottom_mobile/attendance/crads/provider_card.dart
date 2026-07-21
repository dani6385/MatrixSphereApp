// lib/screens/Attendance/widgets/Attendance_body.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_ui/shared_ui.dart';
import '../crads/date_card.dart';
import '../action/attendance_action.dart';
import '../content/attendance_camera.dart';
import '../content/monthly_stats.dart';
import '../providers/attendance_provider.dart';

class ProviderCard extends StatefulWidget {
  const ProviderCard({super.key});

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  // State untuk mengelola alur absensi
  bool _isCheckedIn = false;
  bool _isCheckOutCompleted = false;
  bool _isCameraVisible = false;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    // Mempersiapkan kamera saat widget pertama kali dibuat
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("Tidak ada kamera yang ditemukan.");
        return;
      }
      // Pilih kamera depan, atau kamera pertama jika tidak ada
      final frontCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first);

      // Inisialisasi controller
      _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    } catch (e) {
      debugPrint("Gagal setup kamera: $e");
    }
  }

  // Fungsi ini dipanggil setelah foto berhasil diambil dari AttendanceCamera
  void _handlePictureTaken(XFile? image) {
    if (image != null) {
      // CATAT ABSENSI DI SINI
      context.read<AttendanceProvider>().addAttendance(DateTime.now());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Absensi berhasil direkam: ${image.path}')),
      );

      setState(() {
        if (!_isCheckedIn) {
          _isCheckedIn = true; // Tandai sudah absen masuk
        } else {
          _isCheckOutCompleted = true; // Tandai sudah absen pulang
        }
        _isCameraVisible = false; // Sembunyikan kamera dan kembali ke tombol
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const DateCard(),
          const SizedBox(height: 24),
          if (_isCameraVisible)
            AttendanceCamera(
              controller: _cameraController,
              onPictureTaken: _handlePictureTaken,
              onControllerCreated: (p0) {},
            )
          else
            AttendanceAction(
              isCheckedIn: _isCheckedIn,
              isCheckOutCompleted: _isCheckOutCompleted,
              onCheckIn: () => setState(() => _isCameraVisible = true),
              onCheckOut: () => setState(() => _isCameraVisible = true),
            ),
          const SizedBox(height: 24),
          const MonthlyStats(), // Tampilkan riwayat absensi di sini
        ],
      ),
    );
  }
}
