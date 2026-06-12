import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Indeks untuk melacak tab yang aktif
  int _currentIndex = 0;

  // Daftar halaman polos untuk setiap tab
  final List<Widget> _pages = [
    const Center(child: Text("Halaman Utama", style: TextStyle(fontSize: 18))),
    const Center(child: Text("Halaman Analisis", style: TextStyle(fontSize: 18))),
    const Center(child: Text("Halaman Status", style: TextStyle(fontSize: 18))),
    const Center(child: Text("Halaman Profil", style: TextStyle(fontSize: 18))),
    const Center(child: Text("Halaman Settings", style: TextStyle(fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MatrixSphere")),
      // Menampilkan halaman berdasarkan indeks yang dipilih
      body: _pages[_currentIndex],

      // Standard BottomNavigationBar instead of undefined CustomBottomNavBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ),
    );
  }
}
