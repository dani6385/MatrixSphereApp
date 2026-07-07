import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const SummaryCard({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: theme.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary)),
        ],
      ),
    );
  }
}
