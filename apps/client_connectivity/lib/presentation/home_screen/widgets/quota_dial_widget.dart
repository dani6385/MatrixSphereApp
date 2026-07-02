import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

class QuotaDialWidget extends StatefulWidget {
  final double usedPercent;
  final int usedMB;
  final int totalMB;
  final String packageName;
  final String expiresAt;

  const QuotaDialWidget({
    required this.usedPercent,
    required this.usedMB,
    required this.totalMB,
    required this.packageName,
    required this.expiresAt,
    super.key,
  });

  @override
  State<QuotaDialWidget> createState() => _QuotaDialWidgetState();
}

class _QuotaDialWidgetState extends State<QuotaDialWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _arcAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _arcAnimation = Tween<double>(
      begin: 0,
      end: widget.usedPercent / 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _dialColor {
    if (widget.usedPercent >= 90) return AppColors.error;
    if (widget.usedPercent >= 75) return AppColors.warning;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final remainMB = widget.totalMB - widget.usedMB;
    final remainGB = remainMB / 1024;

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.packageName,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Berlaku hingga ${widget.expiresAt}',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Aktif',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _arcAnimation,
            builder: (context, _) {
              return SizedBox(
                width: 200,
                height: 120,
                child: CustomPaint(
                  painter: _ArcDialPainter(
                    progress: _arcAnimation.value,
                    dialColor: _dialColor,
                    backgroundColor: const Color(0xFFF0F0F0),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.usedPercent.toStringAsFixed(1)}%',
                            style: GoogleFonts.dmSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: _dialColor,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          Text(
                            'Kuota Terpakai',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuotaStatItem(
                  label: 'Terpakai',
                  value:
                      widget.usedMB >= 1024 ? '${(widget.usedMB / 1024).toStringAsFixed(2)} GB' : '${widget.usedMB} MB',
                  color: _dialColor,
                ),
              ),
              Container(width: 1, height: 36, color: const Color(0xFFEEEEEE)),
              Expanded(
                child: _QuotaStatItem(
                  label: 'Tersisa',
                  value: remainGB >= 1
                      ? '${remainGB.toStringAsFixed(2)} GB'
                      : '$remainMB MB',
                  color: const Color(0xFF2E7D32),
                ),
              ),
              Container(width: 1, height: 36, color: const Color(0xFFEEEEEE)),
              Expanded(
                child: _QuotaStatItem(
                  label: 'Total',
                  value: '${(widget.totalMB / 1024).toStringAsFixed(0)} GB',
                  color: const Color(0xFF5C5C5C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuotaStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuotaStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}

class _ArcDialPainter extends CustomPainter {
  final double progress;
  final Color dialColor;
  final Color backgroundColor;

  _ArcDialPainter({
    required this.progress,
    required this.dialColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 12;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Progress arc
    if (progress > 0) {
      final fgPaint = Paint()
        ..color = dialColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * progress,
        false,
        fgPaint,
      );

      // Dot at progress end
      final angle = startAngle + sweepAngle * progress;
      final dotX = center.dx + radius * math.cos(angle);
      final dotY = center.dy + radius * math.sin(angle);
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final dotBorderPaint = Paint()
        ..color = dialColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 9, dotBorderPaint);
      canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArcDialPainter old) =>
      old.progress != progress || old.dialColor != dialColor;
}
