import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

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
              // 2. Navigasi kembali ke halaman login
              Navigator.of(context).pushReplacementNamed(
                '/login',
              ); // Ganti dengan nama rute login Anda
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat Datang di Pusat Kendali Admin!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
