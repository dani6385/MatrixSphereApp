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
    // Menggunakan Scaffold sebagai dasar tata letak
    return Scaffold(
      // Menggunakan Stack untuk menumpuk konten dan bilah navigasi
      body: Stack(
        children: <Widget>[
          // Konten layar utama yang akan berganti-ganti
          // IndexedStack mempertahankan state dari setiap layar saat berganti tab
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Menempatkan bilah navigasi mengambang di bagian bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppNavigation(
              currentIndex: _currentIndex,
              onTapped: _onTapped,
            ),
          ),
        ],
      ),
    );
  }
}
