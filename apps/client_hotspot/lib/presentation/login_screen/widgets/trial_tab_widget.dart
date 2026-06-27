import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/device_provider.dart';
import '../../../routes/app_routes.dart';

class TrialTabWidget extends StatefulWidget {
  const TrialTabWidget({super.key});

  @override
  State<TrialTabWidget> createState() => _TrialTabWidgetState();
}

class _TrialTabWidgetState extends State<TrialTabWidget> {
  bool _isLoading = false;
  String _deviceIdentifier = 'Loading...';
  String _trialUsername = 'Loading...';

  @override
  void initState() {
    super.initState();
    // Menggunakan post-frame callback untuk mengakses provider setelah build pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
      final deviceInfo = deviceProvider.deviceInfo;
      setState(() {
        _deviceIdentifier = deviceInfo?.serialNumber ?? 'Tidak Tersedia';
        // Membuat username trial dari serial number
        _trialUsername = 'T-${_deviceIdentifier.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}';
      });
    });
  }

  Future<void> _loginTrial() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFCE93D8).withAlpha(128),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 36,
                  color: Color(0xFF6A1B9A),
                ),
                const SizedBox(height: 10),
                Text(
                  'Akun Trial Otomatis',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4A148C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Akun trial dibuat otomatis berdasarkan MAC address perangkat Anda. Gratis selama 15 menit.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color(0xFF6A1B9A),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              children: [
                _InfoRow(
                  label: 'Device ID',
                  value: _deviceIdentifier,
                  icon: Icons.devices_rounded,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _InfoRow(
                  label: 'Username Trial',
                  value: _trialUsername,
                  icon: Icons.account_circle_outlined,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _InfoRow(
                  label: 'Durasi',
                  value: '15 Menit',
                  icon: Icons.hourglass_empty_rounded,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _InfoRow(
                  label: 'Kecepatan',
                  value: '512 Kbps',
                  icon: Icons.speed_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Color(0xFFF57F17),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Trial hanya tersedia sekali per perangkat per hari.',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFFF57F17),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _loginTrial,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.play_arrow_rounded, color: Colors.white),
              label: Text(
                _isLoading ? 'Menghubungkan...' : 'Mulai Trial Gratis',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9E9E9E)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: const Color(0xFF757575),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
