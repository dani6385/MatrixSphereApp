import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/hotspot_status_model.dart';
import '../services/rtdb_service.dart';

class StatusNotifier with ChangeNotifier {
  final RtdbService _rtdbService = RtdbService();
  final NetworkInfo _networkInfo = NetworkInfo();

  // PERBAIKAN: Gunakan millidetik untuk timestamp
  HotspotStatus _hotspotStatus = HotspotStatus(
    username: 'N/A',
    ipAddress: '',
    macAddress: '',
    sessionStartTime: DateTime.now().millisecondsSinceEpoch,
    bytesUp: 0,
    bytesDown: 0,
  );
  HotspotStatus get hotspotStatus => _hotspotStatus;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchHotspotStatus() async {
    _isLoading = true;
    _errorMessage = ''; // Hapus error lama saat memulai
    notifyListeners();

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.location.request();
        if (status.isDenied) {
          _errorMessage = 'Izin lokasi diperlukan untuk menemukan alamat IP Wi-Fi Anda. Mohon berikan izin di pengaturan aplikasi.';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      String? ipAddress = await _networkInfo.getWifiIP();
      if (ipAddress != null) {
        _rtdbService.getHotspotStatusStream(ipAddress).listen((status) {
          if (status.macAddress == 'User tidak ditemukan') {
            _errorMessage = 'Sesi hotspot aktif tidak ditemukan untuk perangkat Anda. Pastikan Anda terhubung ke jaringan hotspot yang benar.';
          } else {
            _hotspotStatus = status;
          }
          _isLoading = false;
          notifyListeners();
        }, onError: (error) {
          _errorMessage = 'Gagal mendapatkan data: ${error.toString()}';
          _isLoading = false;
          notifyListeners();
        });
      } else {
        _errorMessage = 'Anda tidak terhubung ke jaringan Wi-Fi. Mohon sambungkan perangkat Anda untuk memeriksa status.';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
}
