
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract class yang mendefinisikan rute navigasi umum.
/// Setiap aplikasi harus menyediakan implementasi konkret dari kelas ini.
abstract class AppNavigation {
  String get homeScreen;
  String get loginScreen;
  String get statusScreen;
  // Tambahkan rute umum lainnya jika ada, misal: profileScreen, etc.
}

/// Provider untuk mengakses implementasi AppNavigation yang aktif.
/// Ini HARUS di-override di root setiap aplikasi.
final appNavigationProvider = Provider<AppNavigation>((ref) {
  throw UnimplementedError(
    'appNavigationProvider harus di-override di dalam ProviderScope.'
  );
});
