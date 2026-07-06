
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/seller/repositories/seller_repository.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Gunakan repository untuk mengelola logika data
  final SellerRepository _sellerRepository = SellerRepository();
  late final Stream<List<TroubledSeller>> _troubledSellersStream;

  @override
  void initState() {
    super.initState();
    // Ambil stream dari repository
    _troubledSellersStream = _sellerRepository.getTroubledSellersStream();
  }

  void _navigateToDetail(TroubledSeller troubledSeller) {
    // Gunakan GoRouter untuk navigasi dan kirim data troubledSeller
    context.push('/seller-detail', extra: troubledSeller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemantauan Mitra'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: StreamBuilder<List<TroubledSeller>>(
        stream: _troubledSellersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada mitra yang perlu dipantau saat ini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final troubledSellers = snapshot.data!;
          return _buildTroubledList(troubledSellers);
        },
      ),
    );
  }

  Widget _buildTroubledList(List<TroubledSeller> troubledSellers) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: troubledSellers.length,
      itemBuilder: (context, index) {
        final troubledSeller = troubledSellers[index];
        final seller = troubledSeller.seller;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              seller.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 5),
              Text(
                'Alasan: ${troubledSeller.reason}',
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Icon(Icons.star_half, color: Colors.amber[800], size: 18), const SizedBox(width: 4), Text('Rating: ${seller.rating}', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 16), Icon(Icons.thumb_down_alt_outlined, color: Colors.grey[600], size: 16), const SizedBox(width: 4), Text('Ulasan Negatif: ${seller.negativeReviews}', style: const TextStyle(fontSize: 14)),
              ],),
            ]),
            onTap: () => _navigateToDetail(troubledSeller),
          ),
        );
      },
    );
  }
}