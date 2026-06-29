import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SessionInfoWidget extends StatefulWidget {
  final String uptime;
  final String sessionTime;
  final bool isTablet;

  const SessionInfoWidget({
    required this.uptime,
    required this.sessionTime,
    required this.isTablet,
    super.key,
  });

  @override
  State<SessionInfoWidget> createState() => _SessionInfoWidgetState();
}

class _SessionInfoWidgetState extends State<SessionInfoWidget> {
  // Live uptime tick — TODO: Replace with [Riverpod/Bloc] stream for production
  late String _uptime;
  late String _sessionTime;

  @override
  void initState() {
    super.initState();
    _uptime = widget.uptime;
    _sessionTime = widget.sessionTime;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SessionCard(
            icon: Icons.timer_outlined,
            iconColor: AppTheme.primary,
            label: 'Uptime',
            value: _uptime,
            subtitle: 'Waktu aktif koneksi',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SessionCard(
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFF0277BD),
            label: 'Sesi',
            value: _sessionTime,
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
