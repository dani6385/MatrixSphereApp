import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SettingAppBar extends StatelessWidget {
  const SettingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: kDarkTextPrimary),
            onPressed: () => Navigator.of(context).pop(), // Menutup laci
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Pengaturan',
            style: textTheme.titleLarge?.copyWith(color: kDarkTextPrimary),
          ),
        ],
      ),
    );
  }
}