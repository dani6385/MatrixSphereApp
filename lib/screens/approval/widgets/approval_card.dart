import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ApprovalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color iconColor;

  const ApprovalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kDarkTextSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        color: kDarkTextPrimary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: kDarkTextSecondary)),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(color: kDarkTextSecondary)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child:
                      const Text('Tolak', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Setujui'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
