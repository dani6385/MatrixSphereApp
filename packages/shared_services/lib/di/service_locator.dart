import 'package:get_it/get_it.dart';
import 'package:shared_services/shared_services.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Mendaftarkan service dari shared_services
  getIt.registerLazySingleton(() => FirestoreService());
  getIt.registerLazySingleton(() => MikrotikService());
  getIt.registerLazySingleton(() => FirebaseAuthService());
}
