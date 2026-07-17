import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../navigation/app_navigator.dart';
import 'package:shared_services/shared_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'screens/home/home_screen.dart';
import 'screens/attendance/attendance_screen.dart';
import 'screens/approval/approval_screen.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Pass all uncaught errors to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
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
            initialRoute: AppRoutes.home,
            onGenerateRoute: AppRouter.onGenerateRoute,
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
      const ApprovalScreen(), // Replaced placeholder
      const Scaffold(body: Center(child: Text('Settings'))),
    ];

    final tabs = [
      const GButton(icon: Icons.home, text: 'Home'),
      const GButton(icon: Icons.calendar_today, text: 'Attendance'),
      const GButton(icon: Icons.approval, text: 'Approval'),
      const GButton(icon: Icons.settings, text: 'Settings'),
    ];

    return CustomBottomNavigationBar(
      screens: screens,
      tabs: tabs,
    );
  }
}
