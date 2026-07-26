
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'package:shop_sphere/screens/shops/contents/featured_card.dart'; // Impor banner biru Anda

class ShopBody extends StatelessWidget {
  const ShopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // 1. BANNER BIRU UNGGULAN
          const FeaturedCard(), 
          
          const SizedBox(height: 16),

          // 2. KARTU INFORMASI PUTIH (Asli Anda, Tanpa Menggunakan Kelas Tidak Dikenal)
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Matrix Sphere',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkTextPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ini adalah widget body yang dipisahkan ke file lain agar kode ShopScreen tetap bersih dan mudah dibaca.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}