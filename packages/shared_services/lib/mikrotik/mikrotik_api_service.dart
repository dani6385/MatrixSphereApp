import 'dart:async';
import 'dart:math' as math;

import 'system_resource.dart';

/// Kelas ini bertanggung jawab untuk berkomunikasi dengan API MikroTik.
/// UNTUK SAAT INI, kelas ini hanya mensimulasikan respons API.
class MikroTikApiService {
  // Properti untuk menyimpan status simulasi yang lebih konsisten
  final DateTime _bootTime = DateTime.now().subtract(Duration(days: math.Random().nextInt(30), hours: math.Random().nextInt(24)));
  final String _ipAddress = "${math.Random().nextInt(254) + 1}";
  final String _macAddress = "${(math.Random().nextInt(90) + 10).toRadixString(16).toUpperCase()}:${(math.Random().nextInt(90) + 10).toRadixString(16).toUpperCase()}:${(math.Random().nextInt(90) + 10).toRadixString(16).toUpperCase()}";
  final String _boardName = ["hEX S", "RB4011iGS+", "hAP ac²", "CCR1009-7G-1C-1S+"][math.Random().nextInt(4)];
  final String _version = "7.${math.Random().nextInt(5) + 12}.${math.Random().nextInt(3)}";
  final String _serialNumber = "SN-MXS-${DateTime.now().year}${math.Random().nextInt(90000) + 10000}";
  // Data simulasi untuk sesi pengguna
  final String _username = 'budi.santoso';
  final String _packageName = 'Paket Harian 1GB';
  final double _quotaUsedPercent = 62.5;
  final int _quotaUsedMB = 625;
  final int _quotaTotalMB = 1000;
  final String _expiresAt = '27 Jun 2026, 23:59';

  String _formatUptime(Duration d) {
    return "${d.inDays}d ${d.inHours % 24}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s";
  }

  /// Mensimulasikan pengambilan data resource sistem dari router.
  ///
  /// Di dunia nyata, ini akan menjadi panggilan HTTP GET ke endpoint
  /// seperti `/rest/system/resource`.
  Future<SystemResource> getSystemResource() async {
    // Mensimulasikan latensi jaringan
    await Future.delayed(const Duration(milliseconds: 150));

    // Membuat data palsu yang dinamis, mirip dengan simulasi sebelumnya
    final uptime = DateTime.now().difference(_bootTime);
    final tx = math.max(0.1, 2.5 + 1.5 * math.sin(DateTime.now().millisecondsSinceEpoch / 2000));
    final rx = math.max(0.2, 9.0 + 5.0 * math.cos(DateTime.now().millisecondsSinceEpoch / 2500));

    // Ini adalah contoh respons JSON yang mungkin Anda dapatkan dari API MikroTik
    // (dengan beberapa data tambahan untuk UI kita).
    final jsonResponse = {
      "ip-address": _ipAddress,
      "mac-address": _macAddress,
      "uptime": _formatUptime(uptime),
      "version": _version, // Firmware version
      "board-name": _boardName, // Device Model
      // Data di bawah ini tidak ada di API asli, kita tambahkan untuk UI
      "serial-number": _serialNumber,
      // Data sesi pengguna
      "username": _username,
      "package-name": _packageName,
      "quota-used-percent": _quotaUsedPercent,
      "quota-used-mb": _quotaUsedMB,
      "quota-total-mb": _quotaTotalMB,
      "expires-at": _expiresAt,
      // Data traffic simulasi
      "simulated-tx": tx, // Upload in Mbps
      "simulated-rx": rx, // Download in Mbps
    };

    return SystemResource.fromJson(jsonResponse);
  }

  /// Mensimulasikan penggunaan voucher.
  ///
  /// Di dunia nyata, ini akan menjadi panggilan HTTP POST ke endpoint
  /// seperti `/rest/ip/hotspot/user/profile/add` atau sejenisnya.
  Future<Map<String, dynamic>> redeemVoucher(String voucherCode) async {
    await Future.delayed(const Duration(seconds: 1));

    if (voucherCode.toUpperCase().contains('INVALID')) {
      throw Exception('Kode voucher tidak valid atau sudah digunakan.');
    }

    // Simulasi penambahan kuota 2GB
    final newTotalMB = _quotaTotalMB + 2000;
    final newQuotaUsedPercent = (_quotaUsedMB / newTotalMB) * 100;

    // Mengembalikan data sesi yang diperbarui
    return {
      "username": _username,
      "package-name": "Paket Voucher 2GB", // Nama paket bisa diubah
      "quota-used-percent": newQuotaUsedPercent,
      "quota-used-mb": _quotaUsedMB,
      "quota-total-mb": newTotalMB,
      "expires-at": "30 Jul 2026, 23:59", // Masa aktif diperpanjang
      // ... sertakan data lain yang tidak berubah jika perlu
      "serial-number": _serialNumber,
      "board-name": _boardName,
      "version": _version,
    };
  }

  // Di masa depan, Anda akan menambahkan metode lain di sini, seperti:
  // Future<List<dynamic>> getActiveUsers() async { ... }
  // Future<void> rebootDevice() async { ... }
}