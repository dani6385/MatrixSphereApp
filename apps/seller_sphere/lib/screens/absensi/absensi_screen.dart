// lib/screens/absensi/absensi_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart'; // Sesuaikan lokasi impor rute Anda

class AbsensiScreen extends StatelessWidget {
  const AbsensiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kLightSurface,
      appBar: AppBar(
        title: const Text('Presensi Kehadiran', style: TextStyle(color: kDarkTextPrimary)),
        centerTitle: true,
        backgroundColor: kLightSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Ringkasan Status Presensi Hari Ini
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.fingerprint, size: 64, color: kBrandPrimary),
                    const SizedBox(height: 12),
                    Text(
                      'Presensi Hari Ini',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kDarkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Senin, 20 Juli 2026', // Contoh tanggal statis, bisa diganti dinamis
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const Divider(height: 32, color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusTime('08:00', 'Jam Masuk', Colors.green),
                        _buildStatusTime('--:--', 'Jam Pulang', Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // TOMBOL UTAMA UNTUK MEMBUKA KAMERA (NAVIGASI)
            ElevatedButton.icon(
              onPressed: () {
                // Menuju rute kamera absen via GoRouter
                GoRouter.of(context).push(AppRoutes.camera); 
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Ambil Presensi (Kamera)', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrandPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTime(String time, String label, Color color) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}