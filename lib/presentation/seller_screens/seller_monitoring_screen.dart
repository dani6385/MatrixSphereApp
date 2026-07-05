import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

// --- DATA MODEL ---
// Model sederhana untuk merepresentasikan data seorang mitra.
// Nantinya, ini akan datang dari database (mis. Firebase).
class _Seller {
  final String id;
  final String name;
  final String storeName;
  final double rating;
  bool isBanned;

  _Seller({
    required this.id,
    required this.name,
    required this.storeName,
    required this.rating,
    this.isBanned = false,
  });
}

// --- SCREEN ---
class SellerMonitoringScreen extends StatefulWidget {
  const SellerMonitoringScreen({super.key});

  @override
  State<SellerMonitoringScreen> createState() => _SellerMonitoringScreenState();
}

class _SellerMonitoringScreenState extends State<SellerMonitoringScreen> {
  // --- DATA MOCK ---
  // Daftar data mitra sementara untuk simulasi.
  final List<_Seller> _sellers = [
    _Seller(id: 'S001', name: 'Budi Santoso', storeName: 'Warung Berkah Jaya', rating: 4.8),
    _Seller(id: 'S002', name: 'Citra Lestari', storeName: 'Toko Kelontong Ceria', rating: 4.5),
    _Seller(id: 'S003', name: 'Agus Setiawan', storeName: 'Sembako Murah Pak Agus', rating: 2.1),
    _Seller(id: 'S004', name: 'Dewi Anggraini', storeName: 'Kebutuhan Harian Dewi', rating: 3.5, isBanned: true),
    _Seller(id: 'S005', name: 'Eko Prasetyo', storeName: 'Toko Eko', rating: 1.9),
  ];

  // Fungsi untuk mengubah status ban seorang mitra
  void _toggleBanStatus(String sellerId) {
    setState(() {
      final seller = _sellers.firstWhere((s) => s.id == sellerId);
      seller.isBanned = !seller.isBanned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Mitra'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md), // 16
        itemCount: _sellers.length,
        itemBuilder: (context, index) {
          final seller = _sellers[index];
          return _SellerCard(
            seller: seller,
            onBanToggled: () => _toggleBanStatus(seller.id),
          );
        },
      ),
    );
  }
}

// --- WIDGET CARD ---
class _SellerCard extends StatelessWidget {
  final _Seller seller;
  final VoidCallback onBanToggled;

  const _SellerCard({required this.seller, required this.onBanToggled});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final bool isLowRating = seller.rating < 3.0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppSpacing.md), // 16
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md), // 16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Baris Nama & Status Ban ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    seller.storeName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: seller.isBanned ? TextDecoration.lineThrough : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (seller.isBanned)
                  Text(
                    '(BANNED)',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            Text(
              'Pemilik: ${seller.name}',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sm), // 8
            const Divider(),
            const SizedBox(height: AppSpacing.sm), // 8
            
            // --- Baris Rating & Tombol Ban ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Rating Bintang ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rating Saat Ini', style: textTheme.bodySmall),
                    Row(
                      children: [
                        Text(
                          seller.rating.toString(),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isLowRating ? colorScheme.error : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs), // 4
                        Icon(
                          Icons.star,
                          size: 20,
                          color: isLowRating ? colorScheme.error : Colors.amber,
                        ),
                      ],
                    ),
                  ],
                ),
                
                // --- Tombol Aksi ---
                ElevatedButton(
                  onPressed: onBanToggled,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: seller.isBanned ? Colors.grey : colorScheme.error,
                    foregroundColor: seller.isBanned ? Colors.black : colorScheme.onError,
                  ),
                  child: Text(seller.isBanned ? 'Unban' : 'Ban Mitra'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
