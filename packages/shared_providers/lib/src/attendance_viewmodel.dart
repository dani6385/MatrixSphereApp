import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';

import 'package:shared_models/shared_models.dart' hide Shop;
import 'package:shared_services/shared_services.dart';



class AttendanceViewModel extends ChangeNotifier {
  final CameraService _cameraService = CameraService();
  final LocationService _locationService = LocationService();
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  final ConfigService _configService = ConfigService();

  // Camera state
  bool _hasCameraPermission = false;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  // UI state
  bool _isScanning = false;
  bool _isCheckingLocation = false;
  String _scanStatusMessage = 'Menunggu absensi...';
  double _scanProgress = 0.0;
  List<AttendanceRecord> _attendanceList = [];
  Shop? _currentShop;

  // State for one-time events (dialogs)
  LocationErrorEvent? _locationErrorEvent;
  ScanSuccessEvent? _scanSuccessEvent;

  bool get isScanning => _isScanning;
  bool get isCheckingLocation => _isCheckingLocation;
  String get scanStatusMessage => _scanStatusMessage;
  double get scanProgress => _scanProgress;
  bool get hasCameraPermission => _hasCameraPermission;
  CameraController? get cameraController => _cameraController;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;
  List<AttendanceRecord> get attendanceList => _attendanceList;
  LocationErrorEvent? get locationErrorEvent => _locationErrorEvent;
  ScanSuccessEvent? get scanSuccessEvent => _scanSuccessEvent;
  Shop? get currentShop => _currentShop;

  void clearLocationErrorEvent() {
    _locationErrorEvent = null;
    // No need to call notifyListeners() as this is a clearing action
  }

  void clearScanSuccessEvent() {
    _scanSuccessEvent = null;
    // No need to call notifyListeners()
  }

  Future<void> initCamera() async {
    // Ambil data toko saat kamera diinisialisasi
    _listenToShopData();
    final result = await _cameraService.initializeCamera();
    _hasCameraPermission = result.permissionGranted;
    _cameraController = result.controller;
    _initializeControllerFuture = result.initializeFuture;
    notifyListeners();
  }

  void _listenToShopData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _rtdbService.getShopStreamByUid(userId).listen((shop) {
        _currentShop = shop;
        notifyListeners();
      });
    }
  }

  Future<void> requestCameraPermission() async {
    await initCamera();
  }

  void disposeCamera() {
    _cameraService.dispose();
  }

  Future<void> startScan({
    required bool isClockIn,
  }) async {
    _isCheckingLocation = true;
    notifyListeners();

    // --- LOGIKA UNTUK ABSENSI TOKO ---
    if (_currentShop?.latitude == null || _currentShop?.longitude == null) {
      _isCheckingLocation = false;
      _locationErrorEvent = LocationErrorEvent(
        'Lokasi Toko Tidak Ditemukan',
        'Data lokasi toko Anda belum diatur. Silakan hubungi admin untuk memperbarui data toko.',
        false, // Tidak perlu tombol settings karena ini masalah data
      );
      notifyListeners();
      return;
    }

    final shopLocation =
        LatLng(_currentShop!.latitude!, _currentShop!.longitude!);

    // Menggunakan metode generik isUserWithinRadius
    final locationResult = await _locationService.isUserWithinRadius(
      targetLocation: shopLocation,
      radiusMeters: 200, // Anda bisa atur radius di sini
    );

    _isCheckingLocation = false;

    if (!locationResult.isWithinRadius) {
      _locationErrorEvent = LocationErrorEvent(
        locationResult.errorTitle,
        locationResult.errorMessage,
        locationResult.needsSettings,
      );
      notifyListeners(); // Notify UI to show the dialog
      return;
    }

    _isScanning = true;
    _scanProgress = 0.0;
    _scanStatusMessage = 'Menganalisis pencahayaan sekitar...';
    notifyListeners();

    // Simulate face scanning process
    _runFaceScanSimulation(
      onSuccess: () {
        // Record attendance to Firebase
        _databaseService.recordAttendance(isClockIn: isClockIn);

        _isScanning = false;
        _scanSuccessEvent = ScanSuccessEvent(
          isClockIn: isClockIn,
          message: "Absen ${isClockIn ? 'Masuk' : 'Pulang'} berhasil diverifikasi dan dicatat.",
        );
        pullAttendanceFromRtdb(); // Refresh history
        // Notify UI to show the dialog and update the list
        notifyListeners();
      },
    );
  }

  /// Starts the attendance process for OFFICE staff.
  Future<void> startOfficeScan({
    required bool isClockIn,
  }) async {
    _isCheckingLocation = true;
    notifyListeners();

    try {
      // 1. Ambil koordinat kantor dari ConfigService
      final LatLng officeLocation = await _configService.getOfficeLocation();

      // 2. Periksa apakah pengguna berada dalam radius kantor
      final locationResult = await _locationService.isUserWithinRadius(
        targetLocation: officeLocation,
        radiusMeters: 100.0, // Radius kantor bisa diatur di sini
      );

      _isCheckingLocation = false;

      if (!locationResult.isWithinRadius) {
        _locationErrorEvent = LocationErrorEvent(
          locationResult.errorTitle,
          locationResult.errorMessage,
          locationResult.needsSettings,
        );
        notifyListeners();
        return;
      }

      // 3. Jika lokasi valid, lanjutkan dengan pemindaian wajah
      _isScanning = true;
      _scanProgress = 0.0;
      _scanStatusMessage = 'Menganalisis pencahayaan sekitar...';
      notifyListeners();

      _runFaceScanSimulation(onSuccess: () {
        _databaseService.recordAttendance(isClockIn: isClockIn);
        _isScanning = false;
        _scanSuccessEvent = ScanSuccessEvent(
          isClockIn: isClockIn,
          message: "Absen Kantor ${isClockIn ? 'Masuk' : 'Pulang'} berhasil dicatat.",
        );
        pullAttendanceFromRtdb();
        notifyListeners();
      });
    } catch (e) {
      _isCheckingLocation = false;
      _locationErrorEvent = LocationErrorEvent('Gagal Konfigurasi', e.toString().replaceAll("Exception: ", ""), false);
      notifyListeners();
    }
  }

  Future<void> _runFaceScanSimulation({required VoidCallback onSuccess}) async {
    final steps = {
      0.1: "Mendeteksi bentuk wajah...",
      0.35: "Memverifikasi struktur biometrik...",
      0.65: "Silakan berkedip untuk deteksi keaktifan...",
      0.9: "Menyesuaikan kredensial...",
      1.0: "Akses Terverifikasi!",
    };

    for (var entry in steps.entries) {
      await Future.delayed(Duration(milliseconds: (entry.key * 1000).toInt() + 600));
      _scanProgress = entry.key;
      _scanStatusMessage = entry.value;
      notifyListeners();
    }
    await Future.delayed(const Duration(milliseconds: 400));
    onSuccess();
  }

  void cancelScan() {
    _isScanning = false;
    notifyListeners();
  }

  /// Fetches attendance history (simulated).
  Future<void> pullAttendanceFromRtdb() async {
    // Fetch real data from Firebase Realtime Database
    _attendanceList = await _databaseService.getAttendanceHistory();
    notifyListeners();
  }
}