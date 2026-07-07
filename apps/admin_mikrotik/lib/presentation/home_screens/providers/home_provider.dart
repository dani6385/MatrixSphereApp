import 'package:flutter/foundation.dart';
import '../models/app_control_model.dart';
import '../models/activity_model.dart';

class HomeProvider with ChangeNotifier {
  List<AppControl> _appControls = [
    AppControl(
      appName: 'Spotify',
      appCategory: 'Hiburan & Musik',
      appIdentifier: 'com.spotify.music',
      usage: 72,
      limit: 240,
      isActive: true,
    ),
    AppControl(
      appName: 'Discord',
      appCategory: 'Komunikasi',
      appIdentifier: 'com.discord',
      usage: 60,
      limit: 120,
      isActive: true,
    ),
    AppControl(
      appName: 'Facebook',
      appCategory: 'Sosial & Video',
      appIdentifier: 'com.facebook.katana',
      usage: 45,
      limit: 120,
      isActive: true,
    ),
  ];

  List<Activity> _activities = [
    Activity(
      activity: 'Admin secara manual membuka blokir akses aplikasi TikTok.',
      timestamp: '18:42:05 06 Jul',
    ),
    Activity(
      activity: 'Admin secara manual memblokir akses aplikasi TikTok.',
      timestamp: '18:42:02 06 Jul',
    ),
    Activity(
      activity: 'Admin secara manual membuka blokir akses aplikasi TikTok.',
      timestamp: '18:42:01 06 Jul',
    ),
    Activity(
      activity: 'Seller `Budi Santoso` (Budi Tech) sedang memperbarui stok barang di tokonya.',
      timestamp: '18:41:59 06 Jul',
    ),
  ];

  List<AppControl> get appControls => _appControls;
  List<Activity> get activities => _activities;
}
