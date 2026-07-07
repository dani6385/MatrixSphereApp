import 'package:flutter/material.dart';
import '../home_screens/home_screen.dart';
import '../seller_screens/seller_screen.dart';
import '../approval_screens/approval_screen.dart';
import '../system_screens/system_screen.dart';
import '../setting_screens/settings_screen.dart';
import '../../widgets/app_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SellerScreen(),
    const ApprovalScreen(),
    const SystemScreen(),
    const SettingsScreen(),
  ];

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: AppNavigation(
        currentIndex: _currentIndex,
        onTapped: _onTapped,
      ),
    );
  }
}
