import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request camera permission for QR scanning
  Future<bool> requestCameraPermission(BuildContext context) async {
    if (kIsWeb) return true;
    return await _requestPermission(
      context,
      permission: Permission.camera,
      title: 'Izin Kamera',
      description:
          'Aplikasi membutuhkan akses kamera untuk memindai QR code voucher dan tiket akses hotspot.',
      icon: Icons.camera_alt_rounded,
    );
  }

  /// Request network/WiFi state permissions (Android only, granted at install)
  Future<bool> requestNetworkPermission(BuildContext context) async {
    if (kIsWeb) return true;
    // ACCESS_NETWORK_STATE & ACCESS_WIFI_STATE are normal permissions
    // granted automatically on Android, no runtime request needed.
    return true;
  }

  /// Request storage permission for saving receipts/QR images
  Future<bool> requestStoragePermission(BuildContext context) async {
    if (kIsWeb) return true;
    return await _requestPermission(
      context,
      permission: Permission.photos,
      title: 'Izin Penyimpanan',
      description:
          'Aplikasi membutuhkan akses penyimpanan untuk menyimpan bukti transaksi dan QR code.',
      icon: Icons.photo_library_rounded,
    );
  }

  /// Request all permissions needed at app startup
  Future<void> requestStartupPermissions(BuildContext context) async {
    if (kIsWeb) return;
    // Camera is the most critical — request it upfront
    await requestCameraPermission(context);
  }

  // ─── Internal helper ────────────────────────────────────────────────────────

  Future<bool> _requestPermission(
    BuildContext context, {
    required Permission permission,
    required String title,
    required String description,
    required IconData icon,
  }) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showPermanentlyDeniedDialog(context, title, description, icon);
      }
      return false;
    }

    // Show rationale dialog before requesting
    if (status.isDenied) {
      if (context.mounted) {
        final shouldRequest = await _showRationaleDialog(
          context,
          title,
          description,
          icon,
        );
        if (!shouldRequest) return false;
      }
    }

    final result = await permission.request();

    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermanentlyDeniedDialog(context, title, description, icon);
    }

    return result.isGranted;
  }

  Future<bool> _showRationaleDialog(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PermissionDialog(
        title: title,
        description: description,
        icon: icon,
        isPermanentlyDenied: false,
      ),
    );
    return result ?? false;
  }

  Future<void> _showPermanentlyDeniedDialog(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PermissionDialog(
        title: title,
        description: description,
        icon: icon,
        isPermanentlyDenied: true,
      ),
    );
  }
}

// ─── Permission Dialog Widget ──────────────────────────────────────────────────

class _PermissionDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isPermanentlyDenied;

  const _PermissionDialog({
    required this.title,
    required this.description,
    required this.icon,
    required this.isPermanentlyDenied,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00BCD4);
    const bgColor = Color(0xFF1A2332);

    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 32),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              description,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: const Color(0xFFB0BEC5),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (isPermanentlyDenied) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFF6B35).withAlpha(80),
                  ),
                ),
                child: Text(
                  'Izin telah ditolak secara permanen. Buka Pengaturan untuk mengaktifkan izin secara manual.',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color(0xFFFF6B35),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF37474F)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Nanti',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: const Color(0xFF90A4AE),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      if (isPermanentlyDenied) {
                        await openAppSettings();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isPermanentlyDenied ? 'Buka Pengaturan' : 'Izinkan',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
