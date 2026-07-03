import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

class WiFiSignalWidget extends StatefulWidget {
  final String ssid;
  final int signalStrength;
  final int signalBars;
  final String connectionType;
  final String channelBand;

  const WiFiSignalWidget({
    required this.ssid,
    required this.signalStrength,
    required this.signalBars,
    required this.connectionType,
    required this.channelBand,
    super.key,
  });

  @override
  State<WiFiSignalWidget> createState() => _WiFiSignalWidgetState();
}

class _WiFiSignalWidgetState extends State<WiFiSignalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _signalLabel {
    if (widget.signalStrength >= -50) return 'Sangat Kuat';
    if (widget.signalStrength >= -60) return 'Kuat';
    if (widget.signalStrength >= -70) return 'Sedang';
    if (widget.signalStrength >= -80) return 'Lemah';
    return 'Sangat Lemah';
  }

  Color get _signalColor {
    if (widget.signalStrength >= -50) return AppTheme.success;
    if (widget.signalStrength >= -60) return AppTheme.primary;
    if (widget.signalStrength >= -70) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Animated WiFi signal arcs
          SizedBox(
            width: 72,
            height: 72,
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, _) {
                return CustomPaint(
                  painter: _WiFiArcPainter(
                    bars: widget.signalBars,
                    color: _signalColor,
                    pulseProgress: _waveAnimation.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.ssid,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _signalColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _signalLabel,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _signalColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _SignalDetail(
                      label: 'dBm',
                      value: '${widget.signalStrength}',
                    ),
                    const SizedBox(width: 16),
                    _SignalDetail(label: 'Tipe', value: widget.connectionType),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.channelBand,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF9E9E9E),
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

class _SignalDetail extends StatelessWidget {
  final String label;
  final String value;
  const _SignalDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: const Color(0xFF9E9E9E),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5C5C5C),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _WiFiArcPainter extends CustomPainter {
  final int bars;
  final Color color;
  final double pulseProgress;

  _WiFiArcPainter({
    required this.bars,
    required this.color,
    required this.pulseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    final arcAngles = [
      (startAngle: -2.2, sweep: 0.8, radius: 10.0),
      (startAngle: -2.4, sweep: 1.2, radius: 20.0),
      (startAngle: -2.6, sweep: 1.6, radius: 30.0),
      (startAngle: -2.8, sweep: 2.0, radius: 40.0),
    ];

    for (int i = 0; i < 4; i++) {
      final isActive = i < bars;
      final arc = arcAngles[i];
      final paint = Paint()
        ..color = isActive
            ? (i == bars - 1
                  ? color.withAlpha(5)
                  : color)
            : const Color(0xFFEEEEEE)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: arc.radius),
        math.pi + arc.startAngle,
        arc.sweep,
        false,
        paint,
      );
    }

    // Center dot
    final dotPaint = Paint()
      ..color = bars > 0 ? color : const Color(0xFFEEEEEE)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _WiFiArcPainter old) =>
      old.bars != bars ||
      old.color != color ||
      old.pulseProgress != pulseProgress;
}
