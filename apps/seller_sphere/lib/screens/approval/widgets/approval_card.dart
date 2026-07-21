import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ApprovalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ApprovalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            subtitle,
            style: textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onReject,
                child: const Text('Tolak', style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: onApprove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: kDarkTextPrimary,
                ),
                child: const Text('Setujui'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
