import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/users_page.dart';
import '../screens/print_page.dart';
import '../screens/settings_page.dart';
import '../screens/profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Indeks untuk menentukan halaman mana yang aktif
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan (tanpa Scaffold di dalamnya)
  final List<Widget> _pages = [
    HomePage(),
    UsersPage(),
    PrintPage(),
    ProfilePage(),
    SettingsPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah otomatis berdasarkan index tanpa menimpa seluruh layar
      body: Column(
        children: [
          Container(
          height: 60,
          width: double.infinity,
          color: Colors.indigo,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Admin Dashboard', // Judul global
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Konten halaman yang berganti-ganti
        Expanded(child: _pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Bagus jika menu lebih dari 2
        currentIndex: _currentIndex,
        onTap: (index) {
          // Cukup ganti index, JANGAN gunakan Navigator.push di sini
          setState(() {
            _currentIndex = index;
          }
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Buat Voucher'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}