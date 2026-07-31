import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
import 'package:seller_sphere/models/attendance_model.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_history_item.dart';
import 'package:shared_ui/shared_ui.dart';

/// Body utama untuk layar Absensi.
///
/// Widget ini bersifat dinamis dan akan menampilkan:
/// - Tampilan pemindaian wajah jika `isScanning` true.
/// - Tampilan permintaan izin jika kamera tidak diizinkan.
/// - Tombol pilihan Clock In/Out jika tidak sedang memindai.
class AttendanceBody extends StatelessWidget {
  final bool isScanning;
  final bool hasCameraPermission;
  final bool isCheckingLocation;
  final CameraController? cameraController;
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;
  final List<AttendanceRecord> attendanceHistory;
  final VoidCallback onSync;

  const AttendanceBody({
    super.key,
    required this.isScanning,
    required this.hasCameraPermission,
    required this.isCheckingLocation,
    this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
    required this.onClockIn,
    required this.onClockOut,
    required this.attendanceHistory,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      // ListView ensures the content is scrollable on smaller screens.
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeaderCard(context),
          const SizedBox(height: 16),
          // Display the appropriate UI based on the isScanning state.
          isScanning
              ? _buildScanningInterface(context)
              : _buildActionButtons(context),
          const SizedBox(height: 24),
          _buildHistoryHeader(context),
          const SizedBox(height: 8),
          _buildHistoryList(context),
        ],
      ),
    );
  }

  /// Membangun kartu header dengan sapaan kepada pengguna.
  Widget _buildHeaderCard(BuildContext context) {
    final ownerName = context.watch<AppViewModel>().ownerName;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.fingerprint_rounded,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Presensi Biometrik Wajah',
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Halo, $ownerName! Silakan lakukan absensi kehadiran harian Anda.',
              style: context.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun antarmuka pemindai atau permintaan izin.
  Widget _buildScanningInterface(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias, // Penting untuk memotong CameraPreview
      child: Container(
        height: 350,
        color: Colors.black,
        child: hasCameraPermission
            ? _buildActiveScanner(context)
            : _buildPermissionRequest(context),
      ),
    );
  }

  /// Membangun tampilan pemindai aktif dengan preview kamera dan overlay.
  Widget _buildActiveScanner(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        // Camera Preview
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(cameraController!),
        ),
        // Scanning Laser Animation
        AnimatedBuilder(
          animation: laserAnimation,
          builder: (context, child) {
            return Positioned(
              top: 350 * laserAnimation.value,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Bottom status panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(scanStatusMessage, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: scanProgress),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onCancelScan,
                  child: const Text('Batalkan', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Membangun tampilan untuk meminta izin kamera.
  Widget _buildPermissionRequest(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off_outlined, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Izin Kamera Dibutuhkan',
            style: context.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Aplikasi memerlukan akses ke kamera depan untuk verifikasi wajah biometrik.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRequestPermission,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Berikan Izin'),
          ),
        ],
      ),
    );
  }

  /// Membangun kartu dengan tombol aksi "Absen Masuk" dan "Absen Pulang".
  Widget _buildActionButtons(BuildContext context) {
    final bool isLoading = isCheckingLocation;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Pilih Tindakan Presensi', style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memeriksa lokasi...'),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      onPressed: onClockIn,
                      icon: Icons.login,
                      label: 'Absen Masuk',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      onPressed: onClockOut,
                      icon: Icons.logout,
                      label: 'Absen Pulang',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk membuat satu tombol aksi (Masuk/Pulang).
  Widget _buildActionButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Builds the header for the attendance history section.
  Widget _buildHistoryHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Riwayat Absensi Kehadiran',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onSync,
          icon: Icon(Icons.cloud_sync_outlined, color: Theme.of(context).colorScheme.primary),
          tooltip: 'Sinkronisasi Data',
        ),
      ],
    );
  }

  /// Builds the list of attendance history records or an empty state message.
  Widget _buildHistoryList(BuildContext context) {
    if (attendanceHistory.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum Ada Riwayat Presensi',
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Lakukan scan wajah untuk memulai perekaman kehadiran harian Anda.',
                style: context.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: attendanceHistory.map((record) => AttendanceHistoryItem(record: record)).toList(),
    );
  }
}