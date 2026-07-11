import 'package:intl/intl.dart';

String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String formatRupiah(double price) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(price);
}

extension StringExtension on String {
  String substringAfterLast(String delimiter) {
    final index = lastIndexOf(delimiter);
    if (index == -1) {
      return this;
    }
    return substring(index + delimiter.length);
  }
}
