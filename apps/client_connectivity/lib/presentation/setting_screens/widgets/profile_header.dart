import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String level;
  final String initial;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.level,
    required this.initial,
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primary,
            child: Text(initial, style: const TextStyle(fontSize: 24, color: textPrimary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: theme.textTheme.titleMedium?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(email, style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary)),
               const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LEVEL: $level',
                  style: theme.textTheme.bodySmall?.copyWith(color: primary, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
