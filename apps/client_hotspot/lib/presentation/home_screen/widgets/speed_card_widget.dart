import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SpeedCardWidget extends StatefulWidget {
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isTablet;

  const SpeedCardWidget({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.isTablet,
    super.key,
  });

  @override
  State<SpeedCardWidget> createState() => _SpeedCardWidgetState();
}

class _SpeedCardWidgetState extends State<SpeedCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, const Color(0xFF00695C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulse.value,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF69F0AE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              Text(
                'Kecepatan Real-time',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(204),
                ),
              ),
              const Spacer(),
              Text(
                'Live',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF69F0AE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SpeedItem(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Download',
                  speed: widget.downloadSpeed,
                  unit: 'Mbps',
                  color: const Color(0xFF69F0AE),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withAlpha(51),
              ),
              Expanded(
                child: _SpeedItem(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Upload',
                  speed: widget.uploadSpeed,
                  unit: 'Mbps',
                  color: const Color(0xFFFFCC80),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double speed;
  final String unit;
  final Color color;

  const _SpeedItem({
    required this.icon,
    required this.label,
    required this.speed,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: Colors.white.withAlpha(191),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: speed.toStringAsFixed(1),
                style: GoogleFonts.dmSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
