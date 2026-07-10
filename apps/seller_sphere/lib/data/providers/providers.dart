
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/data/repositories/app_repository.dart';
import 'package:shared_services/shared_services.dart';

// Provider for FirebaseDatabase instance
final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

// Provider for RtdbService
final rtdbServiceProvider = Provider<RtdbService>((ref) {
  final database = ref.watch(firebaseDatabaseProvider);
  return RtdbService(database);
});

// Provider for AppRepository
final appRepositoryProvider = Provider<AppRepository>((ref) {
  final rtdbService = ref.watch(rtdbServiceProvider);
  return AppRepository(rtdbService);
});
