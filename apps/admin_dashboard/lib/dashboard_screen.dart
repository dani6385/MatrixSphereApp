import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mikrotik_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Statistik real-time dari Firestore (di-update oleh server IoT kamu)
  final Stream<DocumentSnapshot> _statsStream = FirebaseFirestore.instance
      .collection('mikrotik_stats')
      .doc('current')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Monitoring")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _statsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Menunggu data dari IoT..."));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildStatCard("User Aktif", "${data['active_users'] ?? 0}", Icons.people, Colors.blue),
              _buildStatCard("Throughput", "${data['throughput'] ?? 0} Mbps", Icons.speed, Colors.red),
              _buildStatCard("Voucher", "${data['voucher_users'] ?? 0}", Icons.card_membership, Colors.green),
              _buildStatCard("Trial", "${data['trial_users'] ?? 0}", Icons.timer, Colors.orange),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}