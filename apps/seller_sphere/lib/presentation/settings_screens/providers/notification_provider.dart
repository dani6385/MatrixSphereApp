import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  static const NOTIFICATION_STATUS = "NOTIFICATION_STATUS";
  // Secara default, notifikasi dianggap aktif.
  bool _areNotificationsEnabled = true;

  bool get areNotificationsEnabled => _areNotificationsEnabled;

  NotificationProvider() {
    _loadNotificationStatus();
  }

  /// Mengubah status notifikasi dan menyimpannya ke perangkat.
  void toggleNotifications(bool isEnabled) async {
    _areNotificationsEnabled = isEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NOTIFICATION_STATUS, isEnabled);
    notifyListeners();

    // Di sini Anda bisa menambahkan logika untuk mendaftar/berhenti
    // dari layanan push notification seperti Firebase Cloud Messaging.
    // Contoh:
    // if (isEnabled) { FirebaseMessaging.instance.subscribeToTopic('news'); }
    // else { FirebaseMessaging.instance.unsubscribeFromTopic('news'); }
  }

  /// Memuat status notifikasi yang tersimpan saat aplikasi dimulai.
  Future<void> _loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _areNotificationsEnabled = prefs.getBool(NOTIFICATION_STATUS) ?? true;
    notifyListeners();
  }
}