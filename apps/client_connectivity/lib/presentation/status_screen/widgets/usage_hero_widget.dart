import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class UsageHeroWidget extends StatelessWidget {
  final double totalUsageKwh;
  final double downloadTotal;
  final double uploadTotal;

  const UsageHeroWidget({
    required this.totalUsageKwh,
    required this.downloadTotal,
    required this.uploadTotal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${totalUsageKwh.toStringAsFixed(1)} MB',
                  style: GoogleFonts.dmSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: -1,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'Total penggunaan data sesi ini',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MiniStat(
                      icon: Icons.arrow_downward_rounded,
                      color: AppTheme.primary,
                      value: '${downloadTotal.toStringAsFixed(1)} MB',
                      label: 'Unduh',
                    ),
                    const SizedBox(width: 20),
                    _MiniStat(
                      icon: Icons.arrow_upward_rounded,
                      color: AppTheme.secondary,
                      value: '${uploadTotal.toStringAsFixed(1)} MB',
                      label: 'Unggah',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.flash_on_rounded,
              color: AppTheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
