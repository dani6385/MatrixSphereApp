/// Model untuk merepresentasikan data seorang penjual (seller).
///
/// Kelas ini bersifat immutable, yang berarti instance dari kelas ini
/// tidak dapat diubah setelah dibuat.
class Seller {
  final String id;
  final String name;
  final double rating;
  final int negativeReviews;
  final String? status;

  const Seller({
    required this.id,
    required this.name,
    required this.rating,
    required this.negativeReviews,
    this.status,
  });

  /// Factory constructor untuk membuat instance [Seller] dari Map.
  ///
  /// Ini biasanya digunakan saat mengambil data dari Firebase atau sumber data lain
  /// yang berbasis Map.
  factory Seller.fromMap(String id, Map<dynamic, dynamic> map) {
    return Seller(
      id: id,
      name: map['name'] as String? ?? 'Nama Tidak Tersedia',
      rating: (map['rating'] as num? ?? 0.0).toDouble(),
      negativeReviews: (map['negativeReviews'] as num? ?? 0).toInt(),
      status: map['status'] as String?,
    );
  }
}