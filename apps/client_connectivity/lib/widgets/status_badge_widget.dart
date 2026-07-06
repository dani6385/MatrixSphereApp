import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BadgeStatus { active, inactive, warning, error, info, trial }

class StatusBadgeWidget extends StatelessWidget {
  final BadgeStatus status;
  final String label;
  final double? fontSize;

  const StatusBadgeWidget({
    required this.status,
    required this.label,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.w600,
          color: colors.$2,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  (Color, Color) _resolveColors(BadgeStatus s) {
    switch (s) {
      case BadgeStatus.active:
        return (const Color(0xFFE8F5E9), const Color(0xFF2E7D32));
      case BadgeStatus.inactive:
        return (const Color(0xFFF5F5F5), const Color(0xFF757575));
      case BadgeStatus.warning:
        return (const Color(0xFFFFF8E1), const Color(0xFFF57F17));
      case BadgeStatus.error:
        return (const Color(0xFFFFEBEE), const Color(0xFFB71C1C));
      case BadgeStatus.info:
        return (const Color(0xFFE3F2FD), const Color(0xFF0277BD));
      case BadgeStatus.trial:
        return (const Color(0xFFF3E5F5), const Color(0xFF6A1B9A));
    }
  }
}
