import 'package:logger/logger.dart';
import 'package:shared_services/services/rtdb_service.dart';

// Implementasi Web: Semua enum, kelas, dan metode didefinisikan,
// tetapi implementasi fungsionalnya kosong atau mengembalikan status "tidak didukung".

enum IpSyncStatus {
  alreadyInSync,
  syncSuccess,
  syncFailed,
  dataUnavailable,
  notSupported, // Status khusus untuk platform yang tidak didukung
}

class IpSyncResponse {
  final IpSyncStatus status;
  final Map<String, dynamic>? sessionData;

  IpSyncResponse({required this.status, this.sessionData});
}

class IpSyncService {
  final RtdbService rtdbService;
  final Logger logger;

  IpSyncService({required this.rtdbService, required this.logger});

  Future<IpSyncResponse> syncIpAddress({
    required String mikrotikId,
    required String userId,
    required MikroTikRestApiConfig mikrotikRestApiConfig,
  }) async {
    logger.w('IpSyncService tidak didukung pada platform web.');
    // Selalu kembalikan `notSupported` saat dijalankan di web.
    return IpSyncResponse(status: IpSyncStatus.notSupported);
  }
}

class MikroTikRestApiConfig {
  final String host;
  final String username;
  final String password;

  MikroTikRestApiConfig({required this.host, required this.username, this.password = ''});
}
