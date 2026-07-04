import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

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
  // Menggunakan Map untuk menyimpan ulasan, dengan key adalah productId.
  final Map<String, List<Review>> _reviews = {
    // Data dummy untuk ulasan
    '1': [
      Review(id: 'r1', productId: '1', userName: 'Budi', rating: 5, comment: 'Kualitas suaranya jernih banget! Worth it.', date: DateTime.now().subtract(const Duration(days: 2))),
      Review(id: 'r2', productId: '1', userName: 'Citra', rating: 4, comment: 'Desainnya keren, tapi bass-nya kurang nendang buat saya.', date: DateTime.now().subtract(const Duration(days: 1))),
    ],
    '2': [
      Review(id: 'r3', productId: '2', userName: 'Doni', rating: 5, comment: 'Fitur lengkap dan baterai awet. Mantap!', date: DateTime.now().subtract(const Duration(days: 5))),
    ],
  };

  /// Mengambil daftar ulasan untuk produk tertentu.
  List<Review> getReviewsForProduct(String productId) {
    return _reviews[productId] ?? [];
  }

  /// Menghitung rating rata-rata untuk produk tertentu.
  double getAverageRatingForProduct(String productId) {
    final productReviews = getReviewsForProduct(productId);
    if (productReviews.isEmpty) {
      return 0.0;
    }
    final totalRating = productReviews.fold<double>(0.0, (sum, review) => sum + review.rating);
    return totalRating / productReviews.length;
  }

  /// Menambahkan ulasan baru untuk sebuah produk.
  void addReview({
    required String productId,
    required String userName,
    required double rating,
    required String comment,
  }) {
    final newReview = Review(
      id: DateTime.now().toIso8601String(),
      productId: productId,
      userName: userName,
      rating: rating,
      comment: comment,
      date: DateTime.now(),
    );

    if (_reviews.containsKey(productId)) {
      // Tambahkan ke daftar ulasan yang sudah ada
      _reviews[productId]!.insert(0, newReview);
    } else {
      // Buat daftar baru jika ini ulasan pertama untuk produk tsb.
      _reviews[productId] = [newReview];
    }

    notifyListeners();
  }
}