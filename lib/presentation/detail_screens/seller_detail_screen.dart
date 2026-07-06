
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Diperlukan untuk format tanggal
import '../home_screen/home_screen.dart'; // Mengimpor model Seller

// Model untuk data ulasan
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
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] ?? 'Tidak ada komentar.',
      // Menggunakan ISO 8601 string untuk tanggal
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Path ke ulasan untuk penjual spesifik
    _reviewsRef = FirebaseDatabase.instance.ref('reviews/${widget.seller.id}');
    _listenToNegativeReviews();
  }

  void _listenToNegativeReviews() {
    _reviewsRef.onValue.listen((event) {
      if (!mounted) return;

      final newReviews = <Review>[];
      if (event.snapshot.exists) {
        final allReviewsMap = event.snapshot.value as Map<dynamic, dynamic>;
        allReviewsMap.forEach((key, value) {
          final review = Review.fromMap(key, value);
          // Filter hanya ulasan dengan rating < 3.0
          if (review.rating < 3.0) {
            newReviews.add(review);
          }
        });
        // Urutkan ulasan dari yang terbaru
        newReviews.sort((a, b) => b.date.compareTo(a.date));
      }
      setState(() {
        _negativeReviews.clear();
        _negativeReviews.addAll(newReviews);
        _isLoading = false;
      });
    }, onError: (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.seller.name),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            const Text(
              'Ulasan Negatif Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildReviewList()),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_negativeReviews.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada ulasan negatif ditemukan.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _negativeReviews.length,
      itemBuilder: (context, index) {
        final review = _negativeReviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[600], size: 16),
                        const SizedBox(width: 4),
                        Text(review.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(review.comment, style: const TextStyle(height: 1.4)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('d MMM yyyy').format(review.date), // Format tanggal
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widgets lainnya (tidak berubah)
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Masalah',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            _buildInfoRow(
              context,
              icon: Icons.error_outline,
              label: 'Alasan',
              value: widget.seller.reason,
              valueColor: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.star_border,
              label: 'Rating Saat Ini',
              value: widget.seller.rating.toString(),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.comment_bank_outlined,
              label: 'Total Ulasan Negatif',
              value: widget.seller.negativeReviews.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value, Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold, 
            fontSize: 16
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtons(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tindakan Cepat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Logika untuk mengirim peringatan
                },
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Kirim Peringatan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Logika untuk menonaktifkan penjual
                },
                icon: const Icon(Icons.block),
                label: const Text('Nonaktifkan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],  
    );
  }
}
