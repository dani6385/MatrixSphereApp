import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/attendance_record.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_appbar.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_body.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

// This State class now acts as a "Controller" for the screen.
// It holds the state and logic, but the UI is delegated to other widgets.
class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  // Scanning states
  bool _isScanning = false;
  double _scanProgress = 0.0;
  String _scanStatusMessage = "Menunggu absensi...";
  String _lastRecordedTimeMessage = "";

  // Camera permission and controller
  bool _hasCameraPermission = false;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  // Animation
  late AnimationController _laserAnimationController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _initCamera();

    _laserAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _laserAnimationController, curve: Curves.linear),
    );
  }

  Future<void> _initCamera() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );
        _initializeControllerFuture = _cameraController!.initialize();
      }
    }

    if (mounted) {
      setState(() {
        _hasCameraPermission = status.isGranted;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    // The logic is now combined in _initCamera for simplicity
    await _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _laserAnimationController.dispose();
    super.dispose();
  }

  void _startScan(bool isClockIn) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
      _scanStatusMessage = "Menganalisis pencahayaan sekitar...";
    });

    _runFaceScanSimulation(
      onProgress: (progress, message) {
        if (mounted) {
          setState(() {
            _scanProgress = progress;
            _scanStatusMessage = message;
          });
        }
      },
      onSuccess: () async {
        final success = await viewModel.recordAttendance(clockIn: isClockIn);
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
          if (success) {
            _lastRecordedTimeMessage =
                "Absen ${isClockIn ? 'Masuk' : 'Pulang'} tercatat pukul ${DateFormat("HH:mm:ss").format(DateTime.now())}";
            _showScanSuccessDialog();
          } else {
            viewModel.triggerNotification(
              "Informasi Presensi 📅",
              "Anda sudah melakukan presensi ini hari ini.",
            );
          }
        }
      },
    );
  }

  Future<void> _runFaceScanSimulation({
    required void Function(double, String) onProgress,
    required VoidCallback onSuccess,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    onProgress(0.1, "Mendeteksi bentuk wajah...");
    await Future.delayed(const Duration(milliseconds: 800));
    onProgress(0.35, "Memverifikasi struktur biometrik...");
    await Future.delayed(const Duration(milliseconds: 1000));
    onProgress(0.65, "Silakan berkedip untuk deteksi keaktifan...");
    await Future.delayed(const Duration(milliseconds: 700));
    onProgress(0.9, "Menyesuaikan kredensial karyawan...");
    await Future.delayed(const Duration(milliseconds: 400));
    onProgress(1.0, "Akses Terverifikasi!");
    await Future.delayed(const Duration(milliseconds: 400));
    onSuccess();
  }

  void _showScanSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: const Icon(Icons.check_circle, color: kSoftTeal, size: 48),
        title: const Text(
          "Absensi Berhasil!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          "Verifikasi wajah biometrik Anda valid. $_lastRecordedTimeMessage.\nData presensi Anda telah diunggah ke cloud.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: kSoftTeal,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                "Selesai",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AttendanceAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            // While camera is initializing, show a loader.
            if (snapshot.connectionState != ConnectionState.done &&
                _hasCameraPermission) {
              return const Center(child: CircularProgressIndicator());
            }
            // Once camera is ready (or if permission is denied), build the body.
            return AttendanceBody(
              isScanning: _isScanning,
              hasCameraPermission: _hasCameraPermission,
              cameraController: _cameraController,
              laserAnimation: _laserAnimation,
              scanStatusMessage: _scanStatusMessage,
              scanProgress: _scanProgress,
              onCancelScan: () => setState(() => _isScanning = false),
              onRequestPermission: _requestCameraPermission,
              onClockIn: () => _startScan(true),
              onClockOut: () => _startScan(false),
            );
          },
        ),
      ), // This closing parenthesis was missing
    );
  }
}

class AttendanceItemRow extends StatelessWidget {
  final AttendanceRecord record;
  const AttendanceItemRow({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor = record.status == "Hadir"
        ? kSoftTeal
        : record.status == "Terlambat"
        ? const Color(0xFFEAB308)
        : kNeonCyan;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                record.status == "Hadir"
                    ? Icons.verified
                    : record.status == "Terlambat"
                    ? Icons.access_time
                    : Icons.event_available,
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd('id_ID').format(record.date),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Masuk: ${record.clockInTime ?? '--:--:--'}",
                        style: const TextStyle(fontSize: 11),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text("•", style: TextStyle(fontSize: 11)),
                      ),
                      Text(
                        "Pulang: ${record.clockOutTime ?? '--:--:--'}",
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                record.status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
