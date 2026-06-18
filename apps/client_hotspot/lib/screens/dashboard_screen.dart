import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<DataSnapshot>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  // Mengambil username dari sesi dan mempersiapkan future untuk FutureBuilder
  void _initializeUserData() async {
    final String? username = await AuthService.getUsername();
    if (username != null && username.isNotEmpty) {
      final DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$username');
      setState(() {
        _userDataFuture = userRef.get();
      });
    } else {
      // Jika karena suatu alasan username tidak ada, siapkan future dengan error
      setState(() {
        _userDataFuture = Future.error('Sesi pengguna tidak ditemukan.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: FutureBuilder<DataSnapshot>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            // 1. Saat data sedang diambil
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // 2. Jika terjadi error
            if (snapshot.hasError) {
              return Text(
                'Gagal memuat data: ${snapshot.error}',
                style: TextStyle(color: AppTheme.),
              );
            }

            // 3. Jika data berhasil diambil tapi kosong
            if (!snapshot.hasData || snapshot.data?.value == null) {
              return const Text('Data pengguna tidak ditemukan di database.');
            }

            // 4. Jika data berhasil diambil
            final userData = Map<String, dynamic>.from(snapshot.data!.value as Map);
            // Asumsi nama lengkap disimpan di field 'name'
            final String displayName = userData['name'] ?? 'Pengguna'; 

            return Text(
              'Selamat Datang, $displayName!',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
    );
  }
}
