
import 'package:flutter/foundation.dart';
import 'package:shared_services/shared_services.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final int points;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isUnlocked = false,
  });

  factory Achievement.fromMap(String id, Map<dynamic, dynamic> data) {
    return Achievement(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      points: data['points'] ?? 0,
      isUnlocked: data['isUnlocked'] ?? false,
    );
  }
}

class AchievementProvider with ChangeNotifier {
  final RtdbService _rtdbService = RtdbService();
  List<Achievement> _achievements = [];

  AchievementProvider() {
    _rtdbService.getAchievementsStream().listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _achievements = data.entries.map((e) => Achievement.fromMap(e.key, e.value)).toList();
        notifyListeners();
      }
    });
  }

  List<Achievement> get achievements => _achievements;

  int get totalPoints => _achievements.where((a) => a.isUnlocked).fold(0, (sum, a) => sum + a.points);
}
