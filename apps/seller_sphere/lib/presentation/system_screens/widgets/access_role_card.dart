import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class AccessRoleCard extends StatelessWidget {
  final String title;
  final String username;
  final String role;
  final bool isActive;

  const AccessRoleCard({
    super.key,
    required this.title,
    required this.username,
    required this.role,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: surface,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.security, color: primary, size: 24),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: username, style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                      TextSpan(text: ' • ', style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                      TextSpan(text: role, style: theme.textTheme.bodySmall?.copyWith(color: primary)),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF4CAF50).withOpacity(0.2) : const Color(0xFF9E9E9E).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Icon(isActive ? Icons.check_circle : Icons.power_settings_new, color: isActive ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    isActive ? 'AKTIF' : 'NONAKTIF',
                    style: theme.textTheme.bodySmall?.copyWith(color: isActive ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
