import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/models/bottom_nav_item.dart';

/// Kelas abstrak untuk konfigurasi Bottom Navigation.
/// Setiap aplikasi harus menyediakan implementasi konkret dari kelas ini.
abstract class BottomNavConfig {
  /// Daftar item yang akan ditampilkan di bilah navigasi.
  List<BottomNavItem> get items;
}

/// Provider Riverpod untuk mengakses konfigurasi Bottom Navigation.
/// Ini harus di-override di setiap aplikasi untuk menyediakan implementasi
/// yang spesifik.
final bottomNavConfigProvider = Provider<BottomNavConfig>((ref) {
  // Ini adalah implementasi default. Ini akan melempar error jika tidak
  // di-override, yang merupakan perilaku yang kita inginkan untuk memaksa
  // setiap aplikasi menyediakan konfigurasinya sendiri.
  throw UnimplementedError(
    'bottomNavConfigProvider harus di-override di ProviderScope root aplikasi.'
  );
});
