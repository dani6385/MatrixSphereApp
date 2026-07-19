class Violation {
  final String sellerName;
  final String complaint;

  Violation({required this.sellerName, required this.complaint});

  factory Violation.fromMap(String key, Map<dynamic, dynamic> data) {
    return Violation(
      sellerName: key
          .replaceAll('_', ' ')
          .toUpperCase(), // Mengubah 'toko_abang' menjadi 'TOKO ABANG'
      complaint: data['komplain'] ?? 'Tidak ada deskripsi komplain.',
    );
  }
}
