import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigation/app_navigator.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:shared_ui/shared_ui.dart';
import 'screens/home/home_screen.dart';
import 'screens/attendance/attendance_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: const AppNavigator(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const AttendanceScreen(),
      const Scaffold(body: Center(child: Text('History'))),
      const Scaffold(body: Center(child: Text('Settings'))),
    ];

    final tabs = [
      const GButton(icon: Icons.home, text: 'Home'),
      const GButton(icon: Icons.calendar_today, text: 'Attendance'),
      const GButton(icon: Icons.history, text: 'History'),
      const GButton(icon: Icons.settings, text: 'Settings'),
    ];

    return CustomBottomNavigationBar(
      screens: screens,
      tabs: tabs,
    );
  }
}
