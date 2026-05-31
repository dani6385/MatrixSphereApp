import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Kendali Admin'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // 1. Sign out dari Firebase
              await FirebaseAuth.instance.signOut();

              // 2. Arahkan kembali ke halaman login dan hapus riwayat halaman dashboard
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', // Sesuaikan dengan nama route halaman login Anda
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat Datang di Pusat Kendali!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
