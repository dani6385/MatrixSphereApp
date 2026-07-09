
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/app_database.dart';
import 'repository/app_repository.dart';

// 1. Provider untuk AppDatabase
//    Secara asynchronous membuat instance database saat pertama kali dibutuhkan.
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  // Fungsi ini sekarang didefinisikan di dalam app_database.dart
  return await getAppDatabase(); 
});

// 2. Provider untuk AppRepository
//    Provider ini bergantung pada `databaseProvider`.
//    Ia akan menunggu sampai database siap, lalu membuat instance AppRepository
//    dengan DAO yang diperlukan dari instance database tersebut.
final appRepositoryProvider = Provider<AppRepository>((ref) {
  final asyncDb = ref.watch(databaseProvider);

  // Menggunakan pattern matching (Dart 3+) untuk menangani state async dengan aman.
  // Ini akan secara otomatis menangani state loading dan error di UI jika 
  // provider ini di-watch oleh sebuah widget.
  return asyncDb.when(
    data: (database) => AppRepository(
      productDao: database.productDao,
      transactionDao: database.transactionDao,
      targetDao: database.targetDao,
    ),
    loading: () {
      // Selama database loading, kita tidak bisa membuat repository.
      // Melempar error di sini adalah salah satu cara, tapi membiarkan Riverpod 
      // menangani state loading adalah cara yang lebih baik.
      // Widget yang menggunakan provider ini harus menangani state loading.
      throw Exception('Database is not ready yet');
    },
    error: (err, stack) => throw Exception('Failed to load database: $err'),
  );
});
