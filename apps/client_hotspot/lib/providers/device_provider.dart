import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Model untuk menampung informasi perangkat.
class DeviceInfo {
  final String paket;
  final String ipAddress;
  final String macAddress;
  double tx;
  double rx;
  final String deviceModel;
  final String firmwareVersion;
  int uptimeSeconds;
  final String serialNumber;

  DeviceInfo({
    required this.paket,
    required this.ipAddress,
    required this.macAddress,
    required this.tx,
    required this.rx,
    required this.deviceModel,
    required this.firmwareVersion,
    required this.uptimeSeconds,
    required this.serialNumber,
  });
}

class DeviceProvider with ChangeNotifier {
  Timer? _statusTimer;

  // Data awal perangkat, sekarang dikelola oleh Provider.
  final DeviceInfo _deviceInfo = DeviceInfo(
    paket: 'Premium Wi‑Fi 100Mbps',
    ipAddress: '192.168.88.1', // <- Kita satukan IP Address di sini
    macAddress: '00:0C:29:E4:12:F1',
    tx: 2.4, // Mbps
    rx: 8.7, // Mbps
    deviceModel: 'Samsung Galaxy A22 5G',
    firmwareVersion: '12.11',
    uptimeSeconds: 263529, // 3 hari 1 jam 12 menit 9 detik
    serialNumber: 'SN-MXS-202412345',
  );

  DeviceInfo get deviceInfo => _deviceInfo;

  DeviceProvider() {
    _startDataSimulation();
  }

  void _startDataSimulation() {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Perbarui uptime setiap detik
      _deviceInfo.uptimeSeconds++;

      // Simulasikan fluktuasi traffic
      _deviceInfo.tx = math.max(
          0.1, 2.5 + 1.5 * math.sin(DateTime.now().millisecondsSinceEpoch / 2000));
      _deviceInfo.rx = math.max(
          0.2, 9.0 + 5.0 * math.cos(DateTime.now().millisecondsSinceEpoch / 2500));

      // Beri tahu semua listener (widget) bahwa data telah berubah
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
}


