
import 'package:flutter/foundation.dart';
import '../models/hotspot_status_model.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// Simulasi Service untuk mengambil data sesi dari RTDB
class HotspotSessionService {
  Future<HotspotStatus?> getSessionStatusByIp(String ipAddress) async {
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
      String? currentIp;

      // Untuk platform mobile (bukan web), kita butuh izin lokasi
      if (!kIsWeb) {
        // 1. Minta izin lokasi
        var status = await Permission.location.request();
        
        // 2. Periksa hasil permintaan izin
        if (status.isGranted) {
          // Jika diizinkan, lanjutkan untuk mendapatkan IP
          currentIp = await _networkInfo.getWifiIP();
        } else if (status.isDenied) {
          // Jika ditolak sekali, berikan pesan yang jelas
          throw Exception('Izin lokasi ditolak. Fitur ini tidak dapat berjalan tanpa izin lokasi untuk membaca info Wi-Fi.');
        } else if (status.isPermanentlyDenied) {
          // Jika ditolak permanen, sarankan pengguna membuka pengaturan
          throw Exception('Izin lokasi ditolak permanen. Harap buka pengaturan aplikasi untuk memberikan izin lokasi.');
        }
      } else {
        // Untuk web, gunakan IP simulasi
        currentIp = '192.168.88.112';
      }

      if (currentIp == null) {
        throw Exception('Tidak terhubung ke jaringan Wi-Fi atau IP tidak dapat dideteksi.');
      }
      
      // 3. Gunakan IP untuk mencari data sesi di database (simulasi)
      final sessionData = await _sessionService.getSessionStatusByIp(currentIp);

      if (sessionData != null) {
        _hotspotStatus = sessionData;
      } else {
        throw Exception('Sesi Anda untuk IP ($currentIp) tidak ditemukan. Silakan login kembali.');
      }

    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', ''); // Membersihkan prefix "Exception: "
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
