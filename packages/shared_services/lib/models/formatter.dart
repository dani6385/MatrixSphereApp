import 'package:intl/intl.dart';

/// Memformat angka menjadi string mata uang Rupiah (IDR).
///
/// Menggunakan paket `intl` untuk penanganan format angka yang andal.
/// Contoh: 150000 -> "Rp 150.000"
String formatCurrency(num number, {String symbol = 'Rp '}) {
  // Membuat formatter untuk mata uang Indonesia (id_ID)
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: symbol,
    decimalDigits: 0, // Menghilangkan angka di belakang koma
  );
  return formatter.format(number);
}