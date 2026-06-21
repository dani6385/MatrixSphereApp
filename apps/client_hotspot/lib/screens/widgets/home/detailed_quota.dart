import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailedQuota extends StatefulWidget {
  const DetailedQuota({super.key});

  @override
  State<DetailedQuota> createState() => _DetailedQuotaState();
}

class _DetailedQuotaState extends State<DetailedQuota> {
  PermissionStatus? _cameraStatus;
  PermissionStatus? _notificationStatus;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camera = await Permission.camera.status;
    final notification = await Permission.notification.status;
    // setState automatically checks if the widget is mounted.
    setState(() {
      _cameraStatus = camera;
      _notificationStatus = notification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPermissionsCheck(context);
  }

  Widget _buildPermissionsCheck(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lengkapi Kebutuhan Aplikasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Untuk menikmati semua fitur, aplikasi ini memerlukan beberapa izin. Izinkan akses untuk melanjutkan.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _buildPermissionTile(
              context,
              icon: Icons.camera_alt,
              title: 'Akses Kamera',
              status: _cameraStatus,
              onPressed: () => _requestPermission(Permission.camera),
            ),
            const Divider(height: 1, indent: 56),
            _buildPermissionTile(
              context,
              icon: Icons.notifications,
              title: 'Izin Notifikasi',
              status: _notificationStatus,
              onPressed: () => _requestPermission(Permission.notification),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (!mounted) return; // Guard after the first await.

    // Update status after request
    await _checkPermissions();
    if (!mounted) return; // FINAL FIX: Guard after the second await, before using context.

    if (status.isPermanentlyDenied) {
      showDialog(
        context: context, // This is now safe.
        builder: (context) => AlertDialog(
          title: const Text('Izin Dibutuhkan'),
          content: const Text('Izin ini diperlukan untuk fungsionalitas penuh. Silakan aktifkan di pengaturan aplikasi.'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Buka Pengaturan'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPermissionTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onPressed, PermissionStatus? status}) {
    bool isGranted = status?.isGranted ?? false;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: ElevatedButton(
        onPressed: isGranted ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGranted ? Colors.green : Theme.of(context).colorScheme.primary,
          disabledBackgroundColor: Colors.green.withAlpha(150),
        ),
        child: Text(isGranted ? 'Diizinkan' : 'Izinkan'),
      ),
    );
  }
}
