import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import 'activity_item.dart';

class ActivityLog extends StatelessWidget {
  const ActivityLog({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final activities = homeProvider.activities;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: Column(
        children: activities
            .map((activity) => ActivityItem(activity: activity))
            .toList(),
      ),
    );
  }
}
