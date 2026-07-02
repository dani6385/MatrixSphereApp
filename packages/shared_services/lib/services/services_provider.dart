import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'firestore_service.dart';
import 'ip_sync_service.dart';
import 'rtdb_service.dart';

/// Provider untuk instance Logger.
/// Dibuat sebagai singleton di seluruh aplikasi.
final loggerProvider = Provider<Logger>((ref) {
  return Logger();
});

/// Provider untuk FirestoreService.
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// Provider untuk RtdbService.
final rtdbServiceProvider = Provider<RtdbService>((ref) {
  return RtdbService();
});

/// Provider untuk IpSyncService.
/// Provider ini "membaca" provider lain untuk mendapatkan dependensinya.
final ipSyncServiceProvider = Provider<IpSyncService>((ref) {
  final rtdbService = ref.watch(rtdbServiceProvider);
  final logger = ref.watch(loggerProvider);
  return IpSyncService(rtdbService: rtdbService, logger: logger);
});