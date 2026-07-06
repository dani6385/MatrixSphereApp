
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../detail_screens/seller_detail_screen.dart'; // Impor halaman detail

// Model untuk data penjual
class Seller {
  final String id;
  final String name;
  final double rating;
  final int negativeReviews;
  String reason;

  Seller({
    required this.id,
    required this.name,
    required this.rating,
    required this.negativeReviews,
    this.reason = '',
  });

  // Factory constructor untuk membuat instance Seller dari data RTDB
  factory Seller.fromMap(String id, Map<dynamic, dynamic> map) {
    return Seller(
      id: id,
      name: map['name'] ?? 'Nama Tidak Tersedia',
      // Mengatasi tipe data integer dari Firebase
      rating: (map['rating'] as num).toDouble(), 
      negativeReviews: (map['negativeReviews'] as num).toInt(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DatabaseReference _sellersRef;
  StreamSubscription<DatabaseEvent>? _sellersSubscription;

  final List<Seller> _troubledSellers = [];

  @override
  void initState() {
    super.initState();
    _sellersRef = FirebaseDatabase.instance.ref('sellers');
    _listenToSellers();
  }

  void _listenToSellers() {
    _sellersSubscription = _sellersRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final allSellersMap = event.snapshot.value as Map<dynamic, dynamic>;
        final newTroubledSellers = <Seller>[];

        allSellersMap.forEach((key, value) {
          final seller = Seller.fromMap(key, value);
          
          // Logika untuk mengidentifikasi penjual bermasalah
          if (seller.rating < 4.0) {
            seller.reason = 'Rating di Bawah Standar';
            newTroubledSellers.add(seller);
          } else if (seller.negativeReviews > 20) {
            // Anda bisa menambahkan kondisi lain, misal ulasan negatif > 20
            seller.reason = 'Banyak Ulasan Negatif';
            newTroubledSellers.add(seller);
          }
        });

        // Urutkan berdasarkan rating terendah
        newTroubledSellers.sort((a, b) => a.rating.compareTo(b.rating));

        setState(() {
          _troubledSellers.clear();
          _troubledSellers.addAll(newTroubledSellers);
        });
      } else {
        setState(() {
          _troubledSellers.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _sellersSubscription?.cancel();
    super.dispose();
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
        title: const Text('Dashboard Monitor Penjual'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_troubledSellers.isEmpty) {
      // Tampilan jika tidak ada penjual bermasalah
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text(
                'Semua Penjual Baik-Baik Saja',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Tidak ada penjual yang membutuhkan tinjauan saat ini.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Tampilan daftar penjual bermasalah
    return ListView.builder(
      itemCount: _troubledSellers.length,
      itemBuilder: (context, index) {
        final seller = _troubledSellers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              seller.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Alasan: ${seller.reason}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Rating: ${seller.rating}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment, color: Colors.grey, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Ulasan Negatif: ${seller.negativeReviews}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _navigateToDetail(seller), // Navigasi ke halaman detail
          ),
        );
      },
    );
  }
}
