// lib/screens/pages_config.dart
import 'package:flutter/material.dart';
import '../screens/hotspot_screen.dart';
import '../screens/status_screen.dart';
import '../screens/profil_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/dashboard_screen.dart';

class PagesConfig {
  static final List<Widget> pages = [
    const DashboardScreen(),
    const HotspotScreen(),
    const StatusScreen(),
    const ProfilScreen(),
    const SettingsScreen(),
  ];
}

