import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../providers/home_provider.dart';
import 'activity_item.dart';

class ActivityLog extends StatelessWidget {
  const ActivityLog({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final activities = homeProvider.activities;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: activities
              .map((activity) => ActivityItem(activity: activity))
              .toList(),
        ),
      ),
    );
  }
}
