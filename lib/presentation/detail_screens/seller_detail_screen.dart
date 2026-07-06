import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../home_screen/home_screen.dart'; // Mengimpor model Seller

// Model untuk data ulasan (bisa dipindahkan ke file terpisah)
class Review {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromMap(String id, Map<dynamic, dynamic> map) {
    return Review(
      id: id,
      userName: map['userName'] ?? 'Anonim',
      rating: (map['rating'] as num? ?? 0.0).toDouble(),
      comment: map['comment'] ?? 'Tidak ada komentar.',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }
}

class SellerDetailScreen extends StatefulWidget {
  final Seller seller;

  const SellerDetailScreen({Key? key, required this.seller}) : super(key: key);

  @override
  _SellerDetailScreenState createState() => _SellerDetailScreenState();
}

class _SellerDetailScreenState extends State<SellerDetailScreen> {
  late final DatabaseReference _reviewsRef;
  final List<Review> _negativeReviews = [];
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _reviewsRef = FirebaseDatabase.instance.ref('reviews/${widget.seller.id}');
    _listenToNegativeReviews();
  }

  void _listenToNegativeReviews() {
    _reviewsRef.orderByChild('rating').endAt(2.99).onValue.listen((event) {
      if (!mounted) return;
      final reviews = <Review>[];
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          reviews.add(Review.fromMap(key, value));
        });
        reviews.sort((a, b) => b.date.compareTo(a.date)); // Urutkan dari terbaru
      }
      setState(() {
        _negativeReviews.clear();
        _negativeReviews.addAll(reviews);
        _isLoadingReviews = false;
      });
    }, onError: (e) {
      if (!mounted) return;
      setState(() => _isLoadingReviews = false);
    });
  }

  // Fungsi untuk menonaktifkan penjual
  void _deactivateSeller(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Tindakan'),
        content: Text('Anda yakin ingin menonaktifkan mitra "${widget.seller.name}"? Tindakan ini akan menyembunyikan mereka dari daftar pantauan.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final sellerRef = FirebaseDatabase.instance.ref('sellers/${widget.seller.id}');
              sellerRef.update({'status': 'inactive'}).then((_) {
                Navigator.of(ctx).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke HomeScreen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mitra telah dinonaktifkan.'), backgroundColor: Colors.green),
                );
              }).catchError((error) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal: $error'), backgroundColor: Colors.red),
                );
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], foregroundColor: Colors.white),
            child: const Text('Ya, Nonaktifkan'),
          ),
        ],
      ),
    );
  }

  // Placeholder untuk fungsi kirim peringatan
  void _sendWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur "Kirim Peringatan" belum diimplementasikan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.seller.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            const Text('Ulasan Negatif Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildReviewList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    if (_isLoadingReviews) return const Center(child: CircularProgressIndicator());
    if (_negativeReviews.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Tidak ada ulasan negatif.', style: TextStyle(color: Colors.grey))));
    
    return ListView.builder(
      shrinkWrap: true, // Penting di dalam SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Agar tidak ada scroll di dalam scroll
      itemCount: _negativeReviews.length,
      itemBuilder: (context, index) {
        final review = _negativeReviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8), elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(children: [Icon(Icons.star, color: Colors.amber[600], size: 16), const SizedBox(width: 4), Text(review.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold))]),
              ]),
              const SizedBox(height: 8), Text(review.comment, style: const TextStyle(height: 1.4)), const SizedBox(height: 8),
              Align(alignment: Alignment.bottomRight, child: Text(DateFormat('d MMM yyyy').format(review.date), style: const TextStyle(color: Colors.grey, fontSize: 12))),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ringkasan Masalah', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), const Divider(height: 20),
            _buildInfoRow(context, icon: Icons.error_outline, label: 'Alasan', value: widget.seller.reason, valueColor: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            _buildInfoRow(context, icon: Icons.star_border, label: 'Rating Saat Ini', value: widget.seller.rating.toString()),
            const SizedBox(height: 12),
            _buildInfoRow(context, icon: Icons.comment_bank_outlined, label: 'Ulasan Negatif', value: widget.seller.negativeReviews.toString()),
          ],),),);
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value, Color? valueColor}) {
    return Row(children: [
        Icon(icon, color: Colors.grey[600], size: 20), const SizedBox(width: 12), Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)), const Spacer(),
        Text(value, style: TextStyle(color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],);
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Tindakan Cepat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton.icon(onPressed: () => _sendWarning(context), icon: const Icon(Icons.warning_amber_rounded), label: const Text('Kirim Peringatan'), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
            ElevatedButton.icon(onPressed: () => _deactivateSeller(context), icon: const Icon(Icons.block), label: const Text('Nonaktifkan'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
          ],),]);
  }
}
