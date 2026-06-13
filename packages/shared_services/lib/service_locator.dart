import 'package:get_it/get_it.dart';
// Impor barrel file yang mengekspor semua service di paket ini
import 'package:shared_services/shared_services.dart';

// Instance global dari GetIt service locator
final getIt = GetIt.instance;

/// Mendaftarkan semua service ke GetIt
void setupLocator() {
  // Mendaftarkan FirebaseService sebagai Lazy Singleton.
  // Instance hanya akan dibuat sekali saat pertama kali dipanggil.
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
}
