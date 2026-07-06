import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_services/services/ip_sync_service.dart';
import 'package:shared_services/services/rtdb_service.dart'; // Assuming you have this service
import 'package:logger/logger.dart';

import 'home_screen_state.dart';

// 1. Provider Definition
final rtdbServiceProvider = Provider((ref) => RtdbService());
final loggerProvider = Provider((ref) => Logger());

final ipSyncServiceProvider = Provider((ref) {
  final rtdbService = ref.watch(rtdbServiceProvider);
  final logger = ref.watch(loggerProvider);
  return IpSyncService(rtdbService: rtdbService, logger: logger);
});

final homeScreenNotifierProvider =
    StateNotifierProvider<HomeScreenNotifier, HomeScreenState>((ref) {
  final ipSyncService = ref.watch(ipSyncServiceProvider);
  final logger = ref.watch(loggerProvider);
  return HomeScreenNotifier(ipSyncService, logger);
});

// 2. State Notifier Implementation
class HomeScreenNotifier extends StateNotifier<HomeScreenState> {
  final IpSyncService _ipSyncService;
  final Logger _logger;

  HomeScreenNotifier(this._ipSyncService, this._logger)
      : super(const HomeScreenState.initial());

  Future<void> syncIp({
    required String mikrotikId,
    required String userId,
    // You'll need to pass the config, perhaps from another provider or when calling the method
    required dynamic mikrotikRestApiConfig,
  }) async {
    state = const HomeScreenState.loading();
    try {
      final response = await _ipSyncService.syncIpAddress(
        mikrotikId: mikrotikId,
        userId: userId,
        mikrotikRestApiConfig: mikrotikRestApiConfig,
      );

      switch (response.status) {
        case IpSyncStatus.syncSuccess:
        case IpSyncStatus.alreadyInSync:
          if (response.sessionData != null) {
            state = HomeScreenState.success(response.sessionData!);
          } else {
            state = const HomeScreenState.error(
                'Sinkronisasi berhasil tetapi tidak ada data sesi.');
          }
          break;
        case IpSyncStatus.syncFailed:
          state =
              const HomeScreenState.error('Gagal menyinkronkan IP. Silakan coba lagi.');
          break;
        case IpSyncStatus.dataUnavailable:
          state = const HomeScreenState.error(
              'Gagal mendapatkan data sesi atau IP lokal.');
          break;
      }
    } catch (e, stackTrace) {
      _logger.e('An unexpected error occurred during IP sync',
          error: e, stackTrace: stackTrace);
      state = HomeScreenState.error('Terjadi kesalahan yang tidak terduga: $e');
    }
  }
}
