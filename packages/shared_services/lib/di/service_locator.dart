import 'package:get_it/get_it.dart';
import 'package:shared_core/shared_core.dart';
//import 'package:routeros_api/routeros_api.dart';
// packages/shared_services/lib/src/mikrotik/mikrotik_service.dart
// packages/shared_services/lib/di/service_locator.dart

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // 1. Register FirestoreService
  // Menggunakan registerLazySingleton agar service hanya dibuat saat pertama kali dipanggil
  if (!getIt.isRegistered<FirebaseService>()) {
    getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
    getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
    getIt.registerLazySingleton<MikrotikService>(() => MikrotikService());
  }
}
