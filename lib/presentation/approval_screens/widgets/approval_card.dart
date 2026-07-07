import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class ApprovalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String requester;
  final String date;
  final String description;

  const ApprovalCard({
    super.key,
    required this.icon,
    required this.title,
    required this.requester,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: surface,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primary, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(title, style: theme.textTheme.titleMedium?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 2),
                     Text(requester, style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                  ],
                ),
                const Spacer(),
                Text(date, style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Tolak'),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE57373),
                      side: const BorderSide(color: Color(0xFFE57373)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Setujui'),
                    onPressed: () {},
                     style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB6AC),
                      foregroundColor: textPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
