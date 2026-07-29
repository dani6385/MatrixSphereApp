import 'package:flutter/material.dart';
import 'components/management_appbar.dart'; // Impor AppBar Anda
import 'components/management_body.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
