
import 'package:flutter/foundation.dart';

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
}

class AchievementProvider with ChangeNotifier {
  final List<Achievement> _achievements = [
    Achievement(id: '1', title: 'Pendaftaran Pertama', description: 'Mendaftarkan 10 mitra baru.', points: 100, isUnlocked: true),
    Achievement(id: '2', title: 'Penjualan Perdana', description: 'Mencapai penjualan 100 produk.', points: 200),
    Achievement(id: '3', title: 'Mitra Terbanyak', description: 'Memiliki 50 mitra aktif.', points: 500),
    Achievement(id: '4', title: 'Raja Penjualan', description: 'Mencapai total penjualan Rp 10.000.000.', points: 1000, isUnlocked: true),
    Achievement(id: '5', title: 'Penjelajah Wilayah', description: 'Membuka cabang di 5 kota berbeda.', points: 700),
  ];

  List<Achievement> get achievements => _achievements;

  int get totalPoints => _achievements.where((a) => a.isUnlocked).fold(0, (sum, a) => sum + a.points);
}
