import 'package:flutter/material.dart';

/// A styled list tile for displaying recent activities.
class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}