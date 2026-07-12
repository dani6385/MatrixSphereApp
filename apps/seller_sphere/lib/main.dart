
import 'package:flutter/material.dart';
import 'widgets/common/custom_bottom_nav.dart';
import 'widgets/common/main_app_bar.dart';

void main() {
  // Menjalankan aplikasi dengan UI dasar untuk debugging.
  runApp(const MaterialApp(
    home: MinimalDebugApp(),
    debugShowCheckedModeBanner: false,
  ));
}

/// Aplikasi minimal yang telah diperbarui untuk menyertakan AppBar dan BottomNav.
class MinimalDebugApp extends StatefulWidget {
  const MinimalDebugApp({super.key});

  @override
  State<MinimalDebugApp> createState() => _MinimalDebugAppState();
}

class _MinimalDebugAppState extends State<MinimalDebugApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Placeholder sederhana untuk setiap halaman/tab.
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Index 0: Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('Index 1: Streaming', style: TextStyle(fontSize: 24))),
    Center(child: Text('Index 2: Transaction', style: TextStyle(fontSize: 24))),
    Center(child: Text('Index 3: Laporan', style: TextStyle(fontSize: 24))),
    Center(child: Text('Index 4: Trend', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Menggunakan AppBar yang sudah kita perbaiki sebelumnya.
      appBar: const MainAppBar(),

      // 2. Menampilkan halaman placeholder berdasarkan item yang dipilih.
      body: _pages[_selectedIndex],

      // 3. Menambahkan CustomBottomNav.
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
