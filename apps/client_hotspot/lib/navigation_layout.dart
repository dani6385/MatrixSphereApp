import 'package:flutter/material.dart';
import 'screen/home_screen.dart'; // Pastikan sudah mengimpor homescreen.dart
import 'screen/status_screen.dart';
import 'screen/wifi_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/settings_screen.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;

  // Daftar halaman navigasi
  final List<Widget> _pages = [
    const HomeScreen(),
    const StatusScreen(),
    const WifiScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Menggunakan ikon yang tepat agar tidak muncul kotak kosong
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), 
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi), 
            label: 'Wifi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), 
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), 
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple, // Warna aktif
        unselectedItemColor: Colors.grey,     // Warna tidak aktif
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}