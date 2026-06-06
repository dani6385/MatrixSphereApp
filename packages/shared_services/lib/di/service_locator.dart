import 'package:get_it/get_it.dart';
import 'package:shared_services/shared_services.dart';
//import 'package:routeros_api/routeros_api.dart';
// packages/shared_services/lib/src/mikrotik/mikrotik_service.dart
// packages/shared_services/lib/di/service_locator.dart

void setupLocator() {
  // Gunakan registerLazySingleton agar instance dibuat saat pertama kali dipanggil saja
  getIt.registerLazySingleton<MikrotikService>(() => MikrotikService());
}

final getIt = GetIt.instance;