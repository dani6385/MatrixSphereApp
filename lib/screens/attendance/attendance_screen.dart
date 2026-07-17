import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';

import 'package:shared_ui/shared_ui.dart';

import 'widgets/active_employee_card.dart';
import 'widgets/attendance_actions.dart';
import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_button.dart';
import 'widgets/attendance_camera.dart';
import 'widgets/attendance_content.dart';
import 'widgets/attendance_log.dart';
import 'widgets/general_actions.dart';
//import 'widgets/menu_content.dart';
import 'widgets/monthly_stats.dart';
import 'widgets/time_display.dart';


class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // State untuk kamera
  CameraController? _cameraController;
  XFile? _checkInImage;
  XFile? _checkOutImage;

  // State untuk waktu
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  
  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm:ss').format(time);
  }

  void _handleAttendance() async {
    try {
      final imageFile = await _takePicture();
      if (imageFile == null) return;

      setState(() {
        if (_checkInTime == null) {
          // Aksi saat menekan tombol "Absen Masuk"
          _checkInTime = DateTime.now();
          _checkInImage = imageFile;
        } else if (_checkOutTime == null) {
          // Aksi saat menekan tombol "Absen Pulang"
          _checkOutTime = DateTime.now();
          _checkOutImage = imageFile;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
      }
    }
  }

  Future<XFile?> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Kamera belum siap.')));
      return null;
    }
    try {
      final image = await _cameraController!.takePicture();
      return image;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
      return null;
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const AttendanceAppBar(),      
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ActiveEmployeeCard(now: DateTime.now()),
          AttendanceContent( // Removed const from AttendanceContent
            checkInTime: _checkInTime,
            checkOutTime: _checkOutTime,
            // checkInImage: _checkInImage, // Removed as AttendanceContent doesn't use these directly
            // checkOutImage: _checkOutImage, // Removed as AttendanceContent doesn't use these directly
          ),
          const AttendanceActions(),
          const AttendanceLog(),
          const GeneralActions(),
          AttendanceCamera(onControllerCreated: (c) => _cameraController = c), // This should be conditionally rendered or placed elsewhere
          // AttendanceLog(), // This should be inside AttendanceContent or conditionally rendered
          Positioned( // Use Positioned to place elements on top of the Stack
            left: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.lg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(), // Kita pecah bagian card-nya
                AttendanceButton(
                  isCheckedIn: _checkInTime != null,
                  isCompleted: _checkOutTime != null,
                  onPressed: _handleAttendance,
                ),
              ],
            ),
          ),
          const MonthlyStats(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: kDarkSurface.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TimeDisplay(label: 'Masuk', time: _formatTime(_checkInTime), imageFile: _checkInImage),
            TimeDisplay(label: 'Pulang', time: _formatTime(_checkOutTime), imageFile: _checkOutImage),
          ],
        ),
      ),
    );
  }
}