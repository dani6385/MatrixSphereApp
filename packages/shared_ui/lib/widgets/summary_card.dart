import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// A card for displaying a summary metric (e.g., revenue, new orders).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required String title,
    required MaterialColor color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 28, color: iconColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppStyles.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  label,
                  style: AppStyles.bodySmall
                      ?.copyWith(color: context.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
