import 'package:get_it/get_it.dart';
import 'package:shared_services/shared_services.dart';
import '../services/firestore_service.dart';
import '../mikrotik/mikrotik_service.dart';
import '../services/qr_scanner_service.dart';
import '../services/payment_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Mendaftarkan service dari shared_services
  getIt.registerLazySingleton(() => FirestoreService());
  getIt.registerLazySingleton(() => MikrotikService());
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => QrScannerService());
  getIt.registerLazySingleton(() => PaymentService());
}

class FirestoreService {}
