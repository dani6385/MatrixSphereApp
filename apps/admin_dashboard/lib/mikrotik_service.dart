import 'package:routeros_api/routeros_api.dart'; // Pastikan import ini benar
import 'package:flutter/foundation.dart';

class MikrotikService {
  RouterOSApi? _api;

  // Fungsi untuk koneksi ke router
  Future<bool> connect(String ip, String user, String password) async {
    try {
      debugPrint("Mencoba terhubung ke $ip...");
      
      // Menggunakan instance dari RouterOSApi
      // Pastikan parameter host, user, dan password sesuai dengan constructor library
      _api = await RouterOSApi.connect(ip, user, password); 
      
      debugPrint("Berhasil terhubung ke MikroTik!");
      return true;
    } catch (e) {
      debugPrint("Gagal koneksi ke MikroTik: $e");
      return false;
    }
  }

  // Fungsi untuk mengambil data interface
  Future<List<Map<String, dynamic>>> getInterfaces() async {
    // Mengecek apakah _api sudah terinisialisasi dan aktif
    if (_api == null) return [];
    
    try {
      // Mengirim perintah ke MikroTik menggunakan syntax yang umum
      final response = await _api!.sendSync('/interface/print');
      
      // Memastikan data yang dikembalikan berupa List
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Gagal mengambil data interface: $e");
      return [];
    }
  }

  // Fungsi untuk memutus koneksi
  Future<void> disconnectAll() async {
    if (_api != null) {
      _api!.close();
      _api = null;
      debugPrint("Koneksi MikroTik diputus.");
    }
  }
}