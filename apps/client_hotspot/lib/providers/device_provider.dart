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
  final String serialNumber;
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
    required this.serialNumber,
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
    // Data tidak lagi diambil secara otomatis di konstruktor.
    // fetchDeviceInfo() akan dipanggil dari UI setelah izin didapatkan.
  }

  /// Mengambil data awal perangkat dari sumber data (misal: API).
  /// Di sini, kita simulasikan dengan delay.
  Future<void> fetchDeviceInfo() async {
    if (_isLoading) return; // Mencegah fetch berulang jika sedang loading
    _isLoading = true;
    notifyListeners();

    try {
      // Gunakan package untuk mengambil info asli      
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfoPlugin = DeviceInfoPlugin();
      final networkInfo = NetworkInfo();
      String model = 'Unknown';
      String version = 'Unknown';
      String serial = 'Unknown';
      String? ip = await networkInfo.getWifiIP();

      if (kIsWeb) {
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        model = webInfo.browserName.name;
        version = webInfo.appVersion ?? 'N/A';
        serial = 'N/A';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        model = '${androidInfo.manufacturer} ${androidInfo.model}';
        version = 'Android ${androidInfo.version.release}';
        serial = androidInfo.id; // Menggunakan 'id' sebagai pengganti 'serialNumber'
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.name;
        version = 'iOS ${iosInfo.systemVersion}';
        serial = iosInfo.identifierForVendor ?? 'N/A';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        model = 'Windows PC';
        version = 'Build ${windowsInfo.buildNumber}';
        serial = windowsInfo.computerName;
      }

      // Gabungkan data asli dengan data simulasi (traffic, uptime)
      _deviceInfo = DeviceInfo(
        deviceModel: model,
        osVersion: version,
        appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
        ipAddress: ip ?? 'Tidak terhubung ke WiFi',
        uptimeSeconds: 13445, // Simulasi uptime
        tx: 0.8, // Simulasi upload
        rx: 5.4, // Simulasi download
        serialNumber: serial,
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
        _deviceInfo!.tx =
            (1.5 +
                    math.sin(timer.tick * 0.2) * 1.2 +
                    math.Random().nextDouble() * 0.5)
                .clamp(0.1, 15.0);
        _deviceInfo!.rx =
            (6.0 +
                    math.cos(timer.tick * 0.15) * 5.5 +
                    math.Random().nextDouble() * 2.0)
                .clamp(0.2, 30.0);

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
