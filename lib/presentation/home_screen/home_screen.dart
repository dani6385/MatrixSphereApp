import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../detail_screens/seller_detail_screen.dart'; // Pastikan path ini benar

// Model untuk data penjual
class Seller {
  final String id;
  final String name;
  final double rating;
  final int negativeReviews;
  final String? status; // Tambahkan status
  String reason;

  Seller({
    required this.id,
    required this.name,
    required this.rating,
    required this.negativeReviews,
    this.status,
    this.reason = '',
  });

  factory Seller.fromMap(String id, Map<dynamic, dynamic> map) {
    return Seller(
      id: id,
      name: map['name'] ?? 'Nama Tidak Tersedia',
      rating: (map['rating'] as num? ?? 0.0).toDouble(),
      negativeReviews: (map['negativeReviews'] as num? ?? 0).toInt(),
      status: map['status'], // Ambil status dari data
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _sellersRef = FirebaseDatabase.instance.ref('sellers');
  late Stream<List<Seller>> _troubledSellersStream;

  @override
  void initState() {
    super.initState();
    _troubledSellersStream = _sellersRef.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Seller>[];
      }

      final allSellersMap = event.snapshot.value as Map<dynamic, dynamic>;
      final troubledSellers = <Seller>[];

      allSellersMap.forEach((key, value) {
        final seller = Seller.fromMap(key, value as Map<dynamic, dynamic>);
        
        // --- LOGIKA BARU: Filter penjual yang tidak aktif ---
        if (seller.status == 'inactive') {
          return; // Lewati penjual ini
        }

        bool isTroubled = false;
        if (seller.rating > 0 && seller.rating < 4.0) {
          seller.reason = 'Rating Rendah';
          isTroubled = true;
        } else if (seller.negativeReviews > 20) {
          seller.reason = 'Banyak Ulasan Negatif';
          isTroubled = true;
        }

        if (isTroubled) {
          troubledSellers.add(seller);
        }
      });

      troubledSellers.sort((a, b) => a.rating.compareTo(b.rating));
      return troubledSellers;
    });
  }

  void _navigateToDetail(Seller seller) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellerDetailScreen(seller: seller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Monitor'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: StreamBuilder<List<Seller>>(
        stream: _troubledSellersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildAllGoodState();
          }
          final troubledSellers = snapshot.data!;
          return _buildTroubledList(troubledSellers);
        },
      ),
    );
  }

  Widget _buildAllGoodState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green[600], size: 80),
            const SizedBox(height: 16),
            const Text('Semua Mitra Terpantau Baik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Tidak ada mitra yang memerlukan tinjauan saat ini.', style: TextStyle(color: Colors.grey[700]), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubledList(List<Seller> sellers) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: sellers.length,
      itemBuilder: (context, index) {
        final seller = sellers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(seller.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 5),
                Text('Alasan: ${seller.reason}', style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(children: [
                    Icon(Icons.star_half, color: Colors.amber[800], size: 18), const SizedBox(width: 4),
                    Text('Rating: ${seller.rating}', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 16),
                    Icon(Icons.thumb_down_alt_outlined, color: Colors.grey[600], size: 16), const SizedBox(width: 4),
                    Text('Ulasan Negatif: ${seller.negativeReviews}', style: const TextStyle(fontSize: 14)),
                  ],),
              ],),
            trailing: const Icon(Icons.chevron_right_rounded, size: 28),
            onTap: () => _navigateToDetail(seller),
          ),
        );
      },
    );
  }
}
