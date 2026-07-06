
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/achievement_provider.dart';
import 'widgets/achievement_list.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestasi'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => AchievementProvider(),
        child: Consumer<AchievementProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total Poin: ${provider.totalPoints}', style: Theme.of(context).textTheme.headlineSmall),
                ),
                Expanded(child: AchievementList(achievements: provider.achievements)),
              ],
            );
          },
        ),
      ),
    );
  }
}
