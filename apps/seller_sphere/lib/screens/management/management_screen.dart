import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'components/management_appbar.dart'; // Impor AppBar Anda
import 'components/management_body.dart';
import 'package:seller_sphere/navigation/bottom_nav_bar.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tambahkan BottomNavBar di sini
      bottomNavigationBar: BottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
      // 1. Gunakan AppBar yang sudah Anda buat
      appBar: const ManagementAppBar(),

      // 2. Tambahkan properti 'drawer' di sini
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Utama',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                // Aksi ketika item menu diketuk
                Navigator.pop(context); // Menutup drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // 3. (Opsional) Tambahkan juga 'endDrawer' untuk tombol filter
      endDrawer: const Drawer(
        child: Center(
          child: Text('Ini adalah area filter atau pengaturan sisi kanan.'),
        ),
      ),

      // Isi dari halaman Anda
      body: const ManagementBody(),
    );
  }

  // Helper untuk menentukan index terpilih berdasarkan rute saat ini
  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/stream')) return 1;
    if (location.startsWith('/management')) return 2;
    if (location.startsWith('/sellers')) return 3;
    if (location.startsWith('/attendance')) return 4;
    return 0; // Default ke Home
  }

  // Helper untuk navigasi saat item bar diketuk
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/stream');
        break;
      // ... tambahkan case untuk index lainnya
    }
  }
}
