import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:admin_mikrotik/application/providers/session_provider.dart';

// 1. Ubah menjadi ConsumerWidget
class SessionInfoWidget extends ConsumerWidget {
  final bool isTablet;

  // Hapus parameter uptime dan sessionTime dari konstruktor
  const SessionInfoWidget({
    required this.isTablet,
    super.key,
  });

  @override
  // 2. Tambahkan WidgetRef ref ke method build
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Tonton (watch) sessionDataProvider
    final sessionData = ref.watch(sessionDataProvider);

    // 4. Handle state loading/null
    if (sessionData == null) {
      // Tampilkan placeholder atau shimmer effect saat data tidak tersedia
      return const Row(
        children: [
          Expanded(child: _SessionCardPlaceholder()),
          SizedBox(width: 12),
          Expanded(child: _SessionCardPlaceholder()),
        ],
      );
    }

    // 5. Gunakan data dari provider untuk membangun UI
    return Row(
      children: [
        Expanded(
          child: _SessionCard(
            icon: Icons.timer_outlined,
            iconColor: AppTheme.primary,
            label: 'Uptime',
            value: sessionData.uptime, // Gunakan data dari provider
            subtitle: 'Waktu aktif koneksi',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SessionCard(
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFF0277BD),
            label: 'Sesi',
            value: sessionData.sessionTime, // Gunakan data dari provider
            subtitle: 'Durasi sesi ini',
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _SessionCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget placeholder sederhana
class _SessionCardPlaceholder extends StatelessWidget {
  const _SessionCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 50, color: Colors.grey.shade200),
                const SizedBox(height: 4),
                Container(height: 16, width: 80, color: Colors.grey.shade200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
