import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'dart:io'; // Untuk File
import 'package:shared_ui/shared_ui.dart';
import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_button.dart';
import 'widgets/attendance_camera.dart';

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
    // Tentukan status tombol berdasarkan state waktu
    final bool isCheckedIn = _checkInTime != null;
    final bool isCompleted = _checkOutTime != null;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const AttendanceAppBar(),      
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: Camera Preview
          AttendanceCamera(
            onControllerCreated: (controller) {
              _cameraController = controller;
            },
          ),
          // Layer 2: Konten UI di atas kamera
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card untuk menampilkan waktu dan foto
                Card(
                  color: kDarkSurface.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTimeDisplay('Masuk', _formatTime(_checkInTime), _checkInImage),
                        _buildTimeDisplay('Pulang', _formatTime(_checkOutTime), _checkOutImage),
                      ],
                    ),
                  ),
                ),
                // Tombol Absensi
                AttendanceButton(
                  isCheckedIn: isCheckedIn,
                  isCompleted: isCompleted,
                  onPressed: _handleAttendance,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk menampilkan jam
  Widget _buildTimeDisplay(String label, String time, XFile? imageFile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: kDarkBackground,
          backgroundImage: imageFile != null ? FileImage(File(imageFile.path)) : null,
          child: imageFile == null ? const Icon(Icons.person, size: 30, color: kDarkTextSecondary) : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: const TextStyle(color: kDarkTextSecondary, fontSize: 16)),
        const SizedBox(height: AppSpacing.xs),
        Text(time, style: const TextStyle(color: kDarkTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
