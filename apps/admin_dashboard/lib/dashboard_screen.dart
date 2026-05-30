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
            onPressed: () {
              // Kembali ke halaman login
              Navigator.of(context).pop();
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
