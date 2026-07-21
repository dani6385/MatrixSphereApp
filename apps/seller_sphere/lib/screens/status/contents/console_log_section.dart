import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ConsoleLogSection extends StatelessWidget {
  const ConsoleLogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CONSOLE LOG SISTEM',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: kDarkSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '> system idle: menunggu konsensus aktivitas baru...',
            style: textTheme.bodyMedium
                ?.copyWith(color: kDarkTextSecondary, fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
