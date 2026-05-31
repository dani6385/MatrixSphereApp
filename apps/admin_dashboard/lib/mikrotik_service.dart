import 'dart:async';
import 'package:flutter/material.dart';

class MikrotikService {
  final String mikrotikIp = '192.168.88.1';
  final String mikrotikUser = 'admin';
  final String mikrotikPass = 'your_password';

  // Sesuaikan connect agar menerima parameter jika perlu
  Future<bool> connect([String? ip, String? user, String? pass]) async {
    try {
      debugPrint("Connecting to Mikrotik at ${ip ?? mikrotikIp}...");
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint("Failed to connect to Mikrotik: $e");
      return false;
    }
  }

  // Tambahkan metode ini agar tidak error di Dashboard
  Future<void> disconnectAll() async {
    debugPrint("Memutus semua koneksi...");
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void dispose() {
    debugPrint("Disposing Mikrotik service...");
  }
}