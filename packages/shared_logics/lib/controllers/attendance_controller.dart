// lib/screens/attendance/logic/attendance_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

// Import dari paket bersama (shared packages) Anda
import 'package:shared_services/shared_services.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_utils/shared_utils.dart';

class AttendanceController extends ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();

  CameraController? cameraController;
  List<CameraDescription>? _cameras;

  // LOKASI KANTOR (Konfigurasi Admin)
  final OfficeLocationModel officeLocation = OfficeLocationModel(
    latitude: -6.175392,
    longitude: 106.827153,
    allowedRadiusInMeters: 100.0,
  );

  Position? currentPosition;
  double distanceToOffice = 0.0;
  bool isInRange = false;
  bool isLoadingLocation = true;
  bool isCameraInitialized = false;
  bool isProcessing = false;

  // Inisialisasi awal seluruh dependensi
  Future<void> initialize(BuildContext context) async {
    await initializeCamera(context);
    await checkLocationAndPermission(context);
  }

  // Logika mengaktifkan kamera depan
  Future<void> initializeCamera(BuildContext context) async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await cameraController!.initialize();
        isCameraInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      AttendanceDialogs.showSnackBar(context, "Gagal menginisialisasi kamera: $e");
    }
  }

  // Logika memeriksa posisi GPS pengguna
  Future<void> checkLocationAndPermission(BuildContext context) async {
    isLoadingLocation = true;
    notifyListeners();

    try {
      Position position = await _attendanceService.getCurrentLocation();
      double distance = _attendanceService.calculateDistance(position, officeLocation);

      currentPosition = position;
      distanceToOffice = distance;
      isInRange = distance <= officeLocation.allowedRadiusInMeters;
      isLoadingLocation = false;
      notifyListeners();
    } catch (e) {
      AttendanceDialogs.showSnackBar(context, e.toString());
      isLoadingLocation = false;
      notifyListeners();
    }
  }

  // Logika pengambilan foto dan pengiriman data absensi
  Future<void> captureAndVerify(BuildContext context, VoidCallback onSuccess) async {
    if (!isInRange) {
      AttendanceDialogs.showSnackBar(context, "Anda berada di luar jangkauan kantor.");
      return;
    }

    if (cameraController == null || !cameraController!.value.isInitialized || isProcessing) {
      return;
    }

    isProcessing = true;
    notifyListeners();

    try {
      XFile file = await cameraController!.takePicture();

      bool success = await _attendanceService.uploadAttendanceData(
        imageFile: File(file.path),
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        employeeId: '12345',
      );

      if (success) {
        onSuccess();
      } else {
        AttendanceDialogs.showSnackBar(context, "Verifikasi gagal. Silakan coba kembali.");
      }
    } catch (e) {
      AttendanceDialogs.showSnackBar(context, "Terjadi kesalahan: $e");
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}