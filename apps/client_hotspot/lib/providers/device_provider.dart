import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart'; // Tambahkan ini
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Model untuk menampung semua informasi terkait perangkat.
class DeviceInfo {
  final String deviceModel;
  final String osVersion;
  final String ipAddress;
  final String appVersion;
  int uptimeSeconds;
  double tx; // Kecepatan Upload dalam Mbps
  double rx; // Kecepatan Download dalam Mbps

  DeviceInfo({
    required this.deviceModel,
    required this.osVersion,
    required this.ipAddress,
    required this.appVersion,
    required this.uptimeSeconds,
    required this.tx,
    required this.rx,
  });
}


class DeviceProvider with ChangeNotifier {
  DeviceInfo? _deviceInfo;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _updateTimer;

  // Getters untuk mengakses state dari UI
  DeviceInfo? get deviceInfo => _deviceInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DeviceProvider() {
    // Saat provider diinisialisasi, langsung ambil data perangkat.
    fetchDeviceInfo();
  }

  /// Mengambil data awal perangkat dari sumber data (misal: API).
  /// Di sini, kita simulasikan dengan delay.
  Future<void> fetchDeviceInfo() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Gunakan package untuk mengambil info asli
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfoPlugin = DeviceInfoPlugin();
      final networkInfo = NetworkInfo();
      String model = 'Unknown';
      String version = 'Unknown';
      String? ip = await networkInfo.getWifiIP();

      if (kIsWeb) {
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        model = webInfo.browserName.name;
        version = webInfo.appVersion ?? 'N/A';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        model = '${androidInfo.manufacturer} ${androidInfo.model}';
        version = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.name;
        version = 'iOS ${iosInfo.systemVersion}';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        model = 'Windows PC';
        version = 'Build ${windowsInfo.buildNumber}';
      }

      // Gabungkan data asli dengan data simulasi (traffic, uptime)
      _deviceInfo = DeviceInfo(
        deviceModel: model,
        osVersion: version,
        // Menggunakan data dari package_info_plus
        appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
        ipAddress: ip ?? 'Tidak terhubung ke WiFi',
        uptimeSeconds: math.Random().nextInt(10000) + 3600,
        tx: 1.5,
        rx: 5.8,
      );
      _startPeriodicUpdates();
    } catch (e) {
      _errorMessage = "Gagal mengambil data perangkat.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memulai timer yang berjalan setiap detik untuk memperbarui data dinamis.
  void _startPeriodicUpdates() {
    _updateTimer?.cancel(); // Batalkan timer sebelumnya jika ada
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_deviceInfo != null) {
        // Tambah uptime setiap detik
        _deviceInfo!.uptimeSeconds++;

        // Simulasikan fluktuasi traffic Tx dan Rx
        _deviceInfo!.tx = (1.5 + math.sin(timer.tick * 0.2) * 1.2 + math.Random().nextDouble() * 0.5).clamp(0.1, 15.0);
        _deviceInfo!.rx = (6.0 + math.cos(timer.tick * 0.15) * 5.5 + math.Random().nextDouble() * 2.0).clamp(0.2, 30.0);

        // Beri tahu listener (UI) bahwa ada data baru
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    // Hentikan timer saat provider tidak lagi digunakan untuk mencegah memory leak.
    _updateTimer?.cancel();
    super.dispose();
  }
}