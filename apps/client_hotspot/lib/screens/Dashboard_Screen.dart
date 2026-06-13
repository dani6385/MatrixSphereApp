import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Pastikan import ini tetap ada jika diperlukan
 // Pastikan Anda mengimpor file bottom_navbar.dart

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

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
      body: _pages[_currentIndex],

      // Memanggil widget kustom BottomNavbar di sini
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}