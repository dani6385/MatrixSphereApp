import 'package:get_it/get_it.dart';
// Impor barrel file yang mengekspor semua service di paket ini
// import 'package:shared_services/firebase/firebase_service.dart'; // Komentari impor firebase

// Instance global dari GetIt service locator
final getIt = GetIt.instance;

/// Mendaftarkan semua service ke GetIt
void setupServiceLocator() {
  // Mendaftarkan FirebaseService sebagai Lazy Singleton.
  // Instance hanya akan dibuat sekali saat pertama kali dipanggil.
  // getIt.registerLazySingleton<FirebaseService>(() => FirebaseService()); // Komentari pendaftaran service
}
