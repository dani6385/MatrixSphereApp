import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Definisikan Provider Riverpod Global
final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});

// 2. Buat StateNotifier untuk mengelola state notifikasi
class NotificationNotifier extends StateNotifier<bool> {
  static const _notificationStatus = "NOTIFICATION_STATUS";

  // Inisialisasi state awal ke true (notifikasi aktif) dan muat status tersimpan
  NotificationNotifier() : super(true) {
    _loadNotificationStatus();
  }

  /// Mengubah status notifikasi dan menyimpannya ke perangkat.
  void toggleNotifications(bool isEnabled) async {
    state = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationStatus, isEnabled);
    // Logika tambahan seperti subscribe/unsubscribe ke topik FCM bisa ditambahkan di sini
  }

  /// Memuat status notifikasi yang tersimpan saat aplikasi dimulai.
  Future<void> _loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Muat state, default ke true jika tidak ada yang tersimpan
    state = prefs.getBool(_notificationStatus) ?? true;
  }
}
