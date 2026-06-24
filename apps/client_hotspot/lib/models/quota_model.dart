// lib/models/quota_model.dart

class Quota {
  final String nama;
  final double total;
  final double sisa;
  final String validUntil;

  // --- Computed Properties ---
  double get digunakan => total - sisa;
  double get persentaseSisa => (total <= 0) ? 0.0 : sisa / total;
  int get persentaseSisaInt => (persentaseSisa * 100).round();
  bool get isNearlyEmpty => persentaseSisa < 0.1 && sisa > 0;

  // --- Constructor ---
  Quota({
    required this.nama,
    required this.total,
    required this.sisa,
    required this.validUntil,
  });

  // --- Factory Constructor (Map -> Object) ---
  factory Quota.fromMap(Map<String, dynamic> map) {
    return Quota(
      nama: map['nama'] as String? ?? 'Paket Tidak Dikenal',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      sisa: (map['sisa'] as num?)?.toDouble() ?? 0.0,
      validUntil: map['valid_until'] as String? ?? 'N/A',
    );
  }

  // --- Method (Object -> Map) ---
  // Berguna untuk mengirim data atau menyimpannya kembali jika diperlukan.
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'total': total,
      'sisa': sisa,
      'valid_until': validUntil,
      // Properti getter seperti 'digunakan' tidak perlu disimpan
      // karena bisa dihitung kapan saja.
    };
  }
  
  // Method untuk membuat Quota kosong sebagai state awal atau saat error
  static Quota empty() {
    return Quota(
      nama: 'Memuat...',
      total: 1,
      sisa: 0,
      validUntil: '...'
    );
  }
}