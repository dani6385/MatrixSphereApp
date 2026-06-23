
import 'package:flutter/foundation.dart';
import '../models/hotspot_status_model.dart';
import 'package:network_info_plus/network_info_plus.dart';

// Simulasi Service untuk mengambil data sesi dari RTDB
class HotspotSessionService {
  // Di dunia nyata, ini akan mengambil data dari Firebase RTDB berdasarkan IP
  Future<HotspotStatus?> getSessionStatusByIp(String ipAddress) async {
    // --- SIMULASI --- 
    // Kita pura-pura mencari di database dan menemukan data mock jika IP cocok
    if (ipAddress == '192.168.88.112') {
      return Future.delayed(const Duration(seconds: 1), () => HotspotStatus.mockData);
    }
    return null;
  }
}

class StatusNotifier extends ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  final HotspotSessionService _sessionService = HotspotSessionService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HotspotStatus? _hotspotStatus;
  HotspotStatus? get hotspotStatus => _hotspotStatus;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchHotspotStatus() async {
    _isLoading = true;
    _errorMessage = '';
    _hotspotStatus = null;
    notifyListeners();

    try {
      // 1. Dapatkan IP address perangkat saat ini
      final String? currentIp = await _networkInfo.getWifiIP();

      if (currentIp == null) {
        throw Exception('Tidak terhubung ke jaringan Wi-Fi.');
      }
      
      // 2. Gunakan IP untuk mencari data sesi di database (simulasi)
      final status = await _sessionService.getSessionStatusByIp(currentIp);

      if (status != null) {
        _hotspotStatus = status;
      } else {
        throw Exception('Sesi Anda untuk IP ($currentIp) tidak ditemukan. Silakan login kembali.');
      }

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
