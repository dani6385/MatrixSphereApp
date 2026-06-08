import 'package:get_it/get_it.dart';

//import 'package:shared_services/shared_services.dart';
import 'package:shared_core/shared_core.dart';
//import 'package:routeros_api/routeros_api.dart';
// packages/shared_services/lib/src/mikrotik/mikrotik_service.dart
// packages/shared_services/lib/di/service_locator.dart

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // 1. Register FirestoreService
  // Menggunakan registerLazySingleton agar service hanya dibuat saat pertama kali dipanggil
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  // 2. Register MikrotikService
  getIt.registerLazySingleton<MikrotikService>(() => MikrotikService());

  // Tambahkan service lain di sini jika ada, contoh:
  // getIt.registerLazySingleton<AuthService>(() => AuthService());
}