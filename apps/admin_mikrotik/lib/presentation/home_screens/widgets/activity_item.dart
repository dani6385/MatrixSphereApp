import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../models/activity_model.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;

  const ActivityItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 12.0),
            child: CircleAvatar(radius: 3, backgroundColor: primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.activity,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: textPrimary, height: 1.5)),
                const SizedBox(height: 4),
                Text(activity.timestamp,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
