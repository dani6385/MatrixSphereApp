import 'package:flutter/material.dart';

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

      // Menggunakan BottomNavigationBar standar dari Flutter untuk debugging
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analisis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.online_prediction),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        // Menambahkan properti ini agar navbar tidak rusak saat lebih dari 3 item
        type: BottomNavigationBarType.fixed, 
      ),
    );
  }
}
