// lib/screens/Attendance/widgets/Attendance_body.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../crads/date_card.dart';
import '../crads/active_employee_card.dart';
import '../content/attendance_camera.dart';
import '../action/attendance_action.dart';

class AttendanceBody extends StatefulWidget {
  const AttendanceBody({super.key});

  @override
  State<AttendanceBody> createState() => _AttendanceBodyState();
}

class _AttendanceBodyState extends State<AttendanceBody> {
  bool _isCheckedIn = false;
  bool _isCheckOutCompleted = false;
  bool _isCameraVisible = false;
  CameraController? _cameraController;

 @override
 void initState() {
   super.initState();
   _setupCamera();
 }

 Future<void> _setupCamera() async {
   // 1. Dapatkan daftar kamera yang tersedia.
   final cameras = await availableCameras();
   if (cameras.isEmpty) {
     // Handle kasus jika tidak ada kamera yang ditemukan.
     debugPrint("Tidak ada kamera yang ditemukan.");
     return;
   }
   // 2. Pilih kamera depan, atau kamera pertama jika tidak ada.
   final frontCamera = cameras.firstWhere(
       (cam) => cam.lensDirection == CameraLensDirection.front,
       orElse: () => cameras.first);

   // 3. Inisialisasi controller dengan kamera yang dipilih.
   _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
 }

  void _handlePictureTaken(XFile? image) {
    if (image != null) {
      // Logika setelah foto diambil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto berhasil diambil di: ${image.path}')),
      );

      setState(() {
        if (!_isCheckedIn) {
          // Jika ini adalah proses check-in
          _isCheckedIn = true;
        } else {
          // Jika ini adalah proses check-out
          _isCheckOutCompleted = true;
        }
        _isCameraVisible = false; // Sembunyikan kamera setelah selesai
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
          const SizedBox(height: 16),
          ActiveEmployeeCard(now: DateTime.now(), employeeName: 'John Doe', employeeId: 'EMP001'),
          const SizedBox(height: 24),
          if (_isCameraVisible)
            AttendanceCamera(
              controller: _cameraController,
              onPictureTaken: _handlePictureTaken, onControllerCreated: (CameraController? p1) {  },
            )
          else
            AttendanceAction(
              isCheckedIn: _isCheckedIn,
              isCheckOutCompleted: _isCheckOutCompleted,
              onCheckIn: () => setState(() => _isCameraVisible = true),
              onCheckOut: () => setState(() => _isCameraVisible = true),
            ),
        ],
      ),
    );
  }
}