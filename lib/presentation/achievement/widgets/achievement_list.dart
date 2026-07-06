
import 'package:flutter/material.dart';

import '../providers/achievement_provider.dart';

class AchievementList extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementList({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: achievement.isUnlocked ? Colors.green[100] : Colors.grey[200],
          child: ListTile(
            leading: Icon(
              achievement.isUnlocked ? Icons.check_circle : Icons.lock,
              color: achievement.isUnlocked ? Colors.green : Colors.grey,
            ),
            title: Text(achievement.title, style: Theme.of(context).textTheme.titleLarge),
            subtitle: Text(achievement.description),
            trailing: Text('${achievement.points} Poin', style: Theme.of(context).textTheme.titleMedium),
          ),
        );
      },
    );
  }
}
