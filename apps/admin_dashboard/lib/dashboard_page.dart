import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DashboardPage extends StatelessWidget {
  // 1. Menambahkan parameter key
  DashboardPage({super.key});

  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: StreamBuilder<DatabaseEvent>(
        stream: _dbService.getMikrotikData(),
        builder: (context, snapshot) {
          // 2. Menambahkan block {} pada if
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final raw = snapshot.data?.snapshot.value;
          if (raw == null) {
            return const Center(child: Text('Data Kosong'));
          }

          final data = raw as Map<dynamic, dynamic>;

          return ListView(
            children: [
              if (data.containsKey('router'))
                ListTile(title: Text('Router: ${data['router']}')),
              if (data.containsKey('cpu'))
                ListTile(title: Text('CPU Load: ${data['cpu']}%')),
              if (data.containsKey('hotspotUsers'))
                ListTile(
                  title: Text('Active Hotspot: ${data['hotspotUsers']}'),
                ),

              // 3. Menambahkan block {} pada if untuk interfaces
              if (data.containsKey('interfaces') && data['interfaces'] is Map)
                ...((data['interfaces'] as Map).entries.map(
                  (e) => ListTile(
                    title: Text('Interface: ${e.key}'),
                    subtitle: Text('TX: ${e.value['tx']} | RX: ${e.value['rx']}'),
                  ),
                )),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Hotspot'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        type: BottomNavigationBarType.fixed, // Penting jika item lebih dari 3
        onTap: (index) {
          // Logika untuk pindah halaman berdasarkan index
        },
      ),
    );
  }
}
