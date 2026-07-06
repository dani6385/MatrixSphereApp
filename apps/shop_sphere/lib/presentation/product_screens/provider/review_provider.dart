import 'package:flutter/foundation.dart';

/// Model untuk merepresentasikan satu ulasan produk.
class Review {
  final String id;
  final String productId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

/// Provider untuk mengelola data ulasan produk.
class ReviewProvider with ChangeNotifier {
  // Daftar ulasan internal (biasanya ini akan berasal dari database atau API)
  final List<Review> _reviews = [
    Review(
      id: 'r1',
      productId: 'p1',
      userName: 'Andi',
      rating: 4.5,
      comment: 'Produk hebat, sangat menyukainya!',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      id: 'r2',
      productId: 'p1',
      userName: 'Bunga',
      rating: 5.0,
      comment: 'Kualitas luar biasa, akan beli lagi!',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
     Review(
      id: 'r3',
      productId: 'p2',
      userName: 'Citra',
      rating: 3.0,
      comment: 'Cukup bagus, tapi bisa lebih baik.',
      date: DateTime.now(),
    ),
  ];

  /// Mengambil semua ulasan untuk ID produk tertentu.
  List<Review> getReviewsForProduct(String productId) {
    return _reviews.where((review) => review.productId == productId).toList();
  }

  /// Menambahkan ulasan baru dan memberi tahu listener.
  void addReview(Review review) {
    _reviews.add(review);
    notifyListeners(); // Memberi tahu widget yang mendengarkan untuk rebuild
  }

  /// Menghitung rata-rata rating untuk produk tertentu.
  double getAverageRating(String productId) {
    final productReviews = getReviewsForProduct(productId);
    if (productReviews.isEmpty) {
      return 0.0;
    }
    final totalRating = productReviews.fold(0.0, (sum, item) => sum + item.rating);
    return totalRating / productReviews.length;
  }
}
