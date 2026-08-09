import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// A reusable chip widget to display attendance status.
///
/// It takes a status string and a color to style itself accordingly,
/// providing a consistent look for status indicators.
class StatusChip extends StatelessWidget {
  final String status;
  final Color color;

  const StatusChip({
    super.key,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status),
      labelStyle: context.textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
  }
}