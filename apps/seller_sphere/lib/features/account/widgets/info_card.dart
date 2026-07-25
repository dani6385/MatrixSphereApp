import 'package:flutter/material.dart';

/// Widget kartu informasi umum yang dapat digunakan kembali.
class InfoCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final Color titleColor;
  final List<Widget> children;
  final EdgeInsets? childPadding;

  const InfoCard({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.titleColor,
    required this.children,
    this.childPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: childPadding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(titleIcon, color: titleColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}