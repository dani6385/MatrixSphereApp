import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Halaman utama Anda

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan dibuka
  final List<Widget> _pages = [
    const DashboardScreen(), // Halaman Dashboard yang sudah Anda buat
    const Center(child: Text("Halaman Profil")), // Nanti bisa diganti file baru
    const Center(child: Text("Halaman Hotspot Anda")),
    const Center(child: Text("Halaman Status")),
    const Center(child: Text("Halaman Pengaturan")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Hotspot"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Status"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
  }
}