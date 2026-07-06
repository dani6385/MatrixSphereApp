import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. Definisikan Model Data
/// Model ini akan menampung semua informasi yang ditampilkan di StatusScreen.
class StatusData {
  final String packageName;
  final String ipAddress;
  final String macAddress;
  final String gateway;
  final String dns;
  final String ssid;
  final int signalStrength;
  final int signalBars;
  final double totalUsage; // dalam MB
  final double downloadTotal; // dalam MB
  final double uploadTotal; // dalam MB
  final DateTime sessionStart;
  final String connectionType;
  final String channelBand;
  final DateTime lastUpdated;

  const StatusData({
    required this.packageName,
    required this.ipAddress,
    required this.macAddress,
    required this.gateway,
    required this.dns,
    required this.ssid,
    required this.signalStrength,
    required this.signalBars,
    required this.totalUsage,
    required this.downloadTotal,
    required this.uploadTotal,
    required this.sessionStart,
    required this.connectionType,
    required this.channelBand,
    required this.lastUpdated,
  });
}

/// 2. Buat Notifier untuk Mengelola State
/// StateNotifier ini akan mengambil dan memperbarui data status.
class StatusNotifier extends StateNotifier<AsyncValue<StatusData>> {
  StatusNotifier() : super(const AsyncValue.loading()) {
    fetchStatus();
  }

  /// Mengambil data status (simulasi).
  Future<void> fetchStatus() async {
    state = const AsyncValue.loading();
    try {
      // Simulasi panggilan API dengan penundaan
      await Future.delayed(const Duration(milliseconds: 1500));

      // Data mock yang dinamis
      final random = Random();
      final signal = -75 + random.nextInt(45); // -75 to -30 dBm
      final download = 200 + random.nextDouble() * 800; // 200-1000 MB
      final upload = 50 + random.nextDouble() * 200; // 50-250 MB

      final data = StatusData(
        packageName: 'Paket Harian 1GB',
        ipAddress: '192.168.10.${10 + random.nextInt(200)}',
        macAddress: 'A4:C3:F0:8B:2D:1E',
        gateway: '192.168.10.1',
        dns: '8.8.8.8',
        ssid: 'HotspotKafe-01',
        signalStrength: signal,
        signalBars: signal > -55 ? 5 : (signal > -67 ? 4 : (signal > -80 ? 3 : 2)),
        downloadTotal: download,
        uploadTotal: upload,
        totalUsage: download + upload,
        sessionStart: DateTime.now().subtract(const Duration(hours: 1, minutes: 37)),
        connectionType: 'WiFi 802.11n',
        channelBand: '2.4 GHz, Ch 6',
        lastUpdated: DateTime.now(),
      );

      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

/// 3. Definisikan Provider Global
final statusProvider = StateNotifierProvider<StatusNotifier, AsyncValue<StatusData>>((ref) {
  return StatusNotifier();
});