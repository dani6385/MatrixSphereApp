import 'package:flutter/material.dart';
import '../../presentation/approval_screens/approval_screen.dart';
import '../../presentation/home_screens/home_screen.dart';
import '../../presentation/seller_screens/seller_screen.dart';
import '../../presentation/setting_screens/settings_screen.dart';
import '../../presentation/system_screens/system_screen.dart';
import '../../widgets/app_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Menambahkan SettingsScreen ke dalam daftar layar
  final List<Widget> _screens = [
    const HomeScreen(),
    const SellerScreen(),
    const ApprovalScreen(),
    const SystemScreen(),
    const SettingsScreen(), // Layar baru ditambahkan di sini
  ];

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack untuk menempatkan bilah navigasi di atas konten
      body: Stack(
        children: [
          // Konten utama (layar yang sedang aktif)
          // IndexedStack mempertahankan state dari setiap layar saat berganti tab
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Posisi bilah navigasi mengambang di bagian bawah
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
