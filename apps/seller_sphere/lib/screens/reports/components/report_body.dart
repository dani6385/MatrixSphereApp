// lib/features/reports/presentation/screens/reports_screen.dart

import 'package:flutter/material.dart';

class ReportBody extends StatelessWidget {
  const ReportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        body: ListView(
          children: [
            // Kartu Ringkasan Pendapatan Hari Ini
            const Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pendapatan Hari Ini',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rp 1.250.000',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Informasi Grafik Penjualan
            const Text(
              'Grafik Performa Penjualan Mingguan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Area Grafik Bar Chart / Analytics',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      );
  }
}