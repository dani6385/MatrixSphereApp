import 'package:firebase_database/firebase_database.dart';
import '../models/seller_model.dart';

/// Model untuk merepresentasikan penjual yang bermasalah beserta alasannya.
class TroubledSeller {
  final Seller seller;
  final String reason;

  TroubledSeller({required this.seller, required this.reason});
}

/// Repository untuk mengelola data yang berhubungan dengan Seller.
class SellerRepository {
  final DatabaseReference _sellersRef = FirebaseDatabase.instance.ref('sellers');

  /// Mendapatkan stream dari daftar penjual yang bermasalah.
  ///
  /// Penjual dianggap bermasalah jika:
  /// - Rating di bawah 4.0
  /// - Memiliki lebih dari 20 ulasan negatif
  ///
  /// Penjual dengan status 'inactive' akan diabaikan.
  /// Daftar yang dikembalikan diurutkan berdasarkan rating terendah.
  Stream<List<TroubledSeller>> getTroubledSellersStream() {
    return _sellersRef.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <TroubledSeller>[];
      }

      final allSellersMap = event.snapshot.value as Map<dynamic, dynamic>;
      final troubledSellers = <TroubledSeller>[];

      allSellersMap.forEach((key, value) {
        final seller = Seller.fromMap(key, value as Map<dynamic, dynamic>);

        // Lewati penjual yang tidak aktif
        if (seller.status == 'inactive') return;

        if (seller.rating > 0 && seller.rating < 4.0) {
          troubledSellers.add(TroubledSeller(seller: seller, reason: 'Rating Rendah'));
        } else if (seller.negativeReviews > 20) {
          troubledSellers.add(TroubledSeller(seller: seller, reason: 'Banyak Ulasan Negatif'));
        }
      });

      // Urutkan berdasarkan rating dari yang terendah
      troubledSellers.sort((a, b) => a.seller.rating.compareTo(b.seller.rating));
      return troubledSellers;
    });
  }
}