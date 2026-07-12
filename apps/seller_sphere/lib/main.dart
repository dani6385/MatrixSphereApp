
import 'package:flutter/material.dart';

void main() {
  // Menjalankan aplikasi dengan UI yang paling minimalis untuk debugging.
  // Tidak ada inisialisasi database, Firebase, atau proses async lainnya.
  runApp(const MinimalDebugApp());
}

/// Ini adalah aplikasi minimal untuk memastikan Flutter dapat merender halaman.
/// Jika halaman ini muncul, berarti masalahnya ada pada proses inisialisasi
/// atau dependensi pada kode aplikasi Anda yang asli.
class MinimalDebugApp extends StatelessWidget {
  const MinimalDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mode Debug'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: Text(
            'Halaman Kosong Berhasil Ditampilkan.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
