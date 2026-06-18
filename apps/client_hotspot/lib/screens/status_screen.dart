import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  // Listener untuk event dari Firebase
  StreamSubscription<DatabaseEvent>? _activeUserSubscription;
  Map<String, dynamic>? _activeUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenToActiveUser();
  }

  void _listenToActiveUser() {
    // Ganti 'testuser' dengan username yang relevan atau didapat secara dinamis
    DatabaseReference userRef = FirebaseDatabase.instance.ref('hotspot/active_users/testuser');

    _activeUserSubscription = userRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        // Lakukan cast data ke Map<String, dynamic>
        final userData = Map<String, dynamic>.from(data as Map);
        setState(() {
          _activeUser = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _activeUser = null;
          _isLoading = false;
        });
      }
    }, onError: (error) {
      // Handle error jika ada
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $error')),
      );
    });
  }

  @override
  void dispose() {
    // Batalkan listener untuk menghindari memory leak
    _activeUserSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Koneksi'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activeUser != null
              ? _buildStatusCard(_activeUser!)
              : const Center(
                  child: Text('Pengguna tidak aktif atau tidak ditemukan.'),
                ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow('IP Address', user['address']?.toString() ?? 'N/A'),
            _buildStatusRow('Waktu Terhubung', user['uptime']?.toString() ?? 'N/A'),
            _buildStatusRow('TX (Bytes)', user['bytes-out']?.toString() ?? 'N/A'),
            _buildStatusRow('RX (Bytes)', user['bytes-in']?.toString() ?? 'N/A'),
            _buildStatusRow('Session Time Left', user['session-time-left']?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
