import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_services/services/ip_sync_service.dart';
import 'package:shared_services/services/rtdb_service.dart'; // Assuming you have this service
import 'package:logger/logger.dart';

import 'home_screen_state.dart';

// 1. Provider Definition
final homeScreenNotifierProvider =
    StateNotifierProvider<HomeScreenNotifier, HomeScreenState>((ref) {
  // Services from other providers would be passed here, for now, we instantiate them
  // This should be adapted based on how your services are provided.
  final rtdbService = RtdbService(); // This should be provided by another provider
  final logger = Logger();
  final ipSyncService = IpSyncService(rtdbService: rtdbService, logger: logger);

  return HomeScreenNotifier(ipSyncService, logger);
});

// 2. The Notifier itself
class HomeScreenNotifier extends StateNotifier<HomeScreenState> {
  final IpSyncService _ipSyncService;
  final Logger _logger;

  HomeScreenNotifier(this._ipSyncService, this._logger) : super(const HomeScreenState.initial());

  Future<void> syncIpAddress(String mikrotikId, String userId, MikroTikRestApiConfig config) async {
    _logger.i('Starting IP sync process...');
    state = const HomeScreenState.loading();
    try {
      final response = await _ipSyncService.syncIpAddress(
        mikrotikId: mikrotikId,
        userId: userId,
        mikrotikRestApiConfig: config,
      );

      _logger.i('IP sync process finished with status: ${response.status}');

      switch (response.status) {
        case IpSyncStatus.syncSuccess:
        case IpSyncStatus.alreadyInSync:
          if (response.sessionData != null) {
            state = HomeScreenState.success(response.sessionData!);
          } else {
            state = const HomeScreenState.error('Sinkronisasi berhasil tetapi tidak ada data sesi.');
          }
          break;
        case IpSyncStatus.syncFailed:
          state = const HomeScreenState.error('Gagal menyinkronkan IP. Silakan coba lagi.');
          break;
        case IpSyncStatus.dataUnavailable:
          state = const HomeScreenState.error('Gagal mendapatkan data sesi atau IP lokal.');
          break;
      }
    } catch (e, stackTrace) {
      _logger.e('An unexpected error occurred during IP sync', error: e, stackTrace: stackTrace);
      state = HomeScreenState.error('Terjadi kesalahan yang tidak terduga: $e');
    }
  }
}
