import 'package:flutter/material.dart';

/// Widget untuk menampilkan sebaris detail akun (label dan value) dengan ikon.
class AccountDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const AccountDetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2), width: 0.5),
          ),
          child: Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.4, // line-height
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}