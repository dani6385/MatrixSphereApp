
import 'package:flutter/material.dart';

// Model sederhana untuk data penjual yang bermasalah
class TroubledSeller {
  final String name;
  final String reason;
  final double rating;
  final int negativeReviews;

  TroubledSeller({
    required this.name,
    required this.reason,
    required this.rating,
    required this.negativeReviews,
  });
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // Data dummy untuk penjual yang bermasalah
  final List<TroubledSeller> troubledSellers = [
    TroubledSeller(
        name: 'Toko Elektronik Jaya',
        reason: 'Rating Turun Drastis',
        rating: 3.2,
        negativeReviews: 15),
    TroubledSeller(
        name: 'Fashion Wanita Murah',
        reason: 'Banyak Ulasan Negatif',
        rating: 3.8,
        negativeReviews: 25),
    TroubledSeller(
        name: 'Gadget Store',
        reason: 'Rating di Bawah Standar',
        rating: 3.4,
        negativeReviews: 8),
    TroubledSeller(
        name: 'Perabotan Rumah Tangga',
        reason: 'Ulasan Buruk Meningkat',
        rating: 4.1,
        negativeReviews: 12),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Penjual Bermasalah'),
      ),
      body: ListView.builder(
        itemCount: troubledSellers.length,
        itemBuilder: (context, index) {
          final seller = troubledSellers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                seller.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      const Icon(Icons.comment,
                          color: Colors.grey, size: 18),
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
              onTap: () {
                // Navigasi ke halaman detail penjual untuk investigasi lebih lanjut
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SellerDetailScreen(seller: seller)));
              },
            ),
          );
        },
      ),
    );
  }
}
