import 'package:flutter/material.dart';
import '../models/seller_model.dart';
import 'filter_chip.dart';
import 'seller_card.dart';

class SellerContent extends StatelessWidget {
  const SellerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MANAJEMEN SELLER',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Daftar penjual terdaftar di sistem',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(label: 'Semua', selected: true),
                SizedBox(width: 8),
                FilterChipWidget(label: 'Pending'),
                SizedBox(width: 8),
                FilterChipWidget(label: 'Aktif'),
                SizedBox(width: 8),
                FilterChipWidget(label: 'Ditolak'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                SellerCard(
                  seller: Seller(
                    icon: Icons.storefront,
                    iconColor: Colors.green,
                    storeName: 'Cyber Tech Store',
                    ownerName: 'Ana Syafitri',
                    email: 'ana@matrix.net',
                    phone: '+6281123456789',
                    status: 'AKTIF',
                    statusColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                SellerCard(
                  seller: Seller(
                    icon: Icons.lightbulb_outline,
                    iconColor: Colors.orange,
                    storeName: 'Quantum Computing',
                    ownerName: 'Budi Hermawan',
                    email: 'budi@sphere.org',
                    phone: '+628571234567',
                    status: 'PENDING VERIFIKASI',
                    statusColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
