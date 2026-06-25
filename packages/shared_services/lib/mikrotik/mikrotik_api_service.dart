import 'dart:async';
import 'dart:math' as math;

/// Kelas ini bertanggung jawab untuk berkomunikasi dengan API MikroTik.
/// UNTUK SAAT INI, kelas ini hanya mensimulasikan respons API.
class MikroTikApiService {
  // Properti untuk menyimpan status simulasi yang lebih konsisten
  final DateTime _bootTime = DateTime.now().subtract(Duration(days: math.Random().nextInt(30), hours: math.Random().nextInt(24)));
  final String _ipAddress = "${math.Random().nextInt(254) + 1}";
  final String _macAddress = "${(math.Random().nextInt(90) + 10).toRadixString(16).toUpperCase()}:${(math.Random().nextInt(90) + 10).toRadixString(16).toUpperCase()}:${(math.Random().nextInt(90) + 10).toRadixString(16).toUpperCase()}";
  final String _boardName = ["hEX S", "RB4011iGS+", "hAP ac²", "CCR1009-7G-1C-1S+"][math.Random().nextInt(4)];
  final String _version = "7.${math.Random().nextInt(5) + 12}.${math.Random().nextInt(3)}";
  final String _paket = ["Basic 20Mbps", "Standard 50Mbps", "Premium 100Mbps"][math.Random().nextInt(3)];
  final String _serialNumber = "SN-MXS-${DateTime.now().year}${math.Random().nextInt(90000) + 10000}";

  String _formatUptime(Duration d) {
    return "${d.inDays}d ${d.inHours % 24}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s";
  }

  /// Mensimulasikan pengambilan data resource sistem dari router.
  ///
  /// Di dunia nyata, ini akan menjadi panggilan HTTP GET ke endpoint
  /// seperti `/rest/system/resource`.
  Future<Map<String, dynamic>> getSystemResource() async {
    // Mensimulasikan latensi jaringan
    await Future.delayed(const Duration(milliseconds: 150));

    // Membuat data palsu yang dinamis, mirip dengan simulasi sebelumnya
    final uptime = DateTime.now().difference(_bootTime);
    final tx = math.max(0.1, 2.5 + 1.5 * math.sin(DateTime.now().millisecondsSinceEpoch / 2000));
    final rx = math.max(0.2, 9.0 + 5.0 * math.cos(DateTime.now().millisecondsSinceEpoch / 2500));

    // Ini adalah contoh respons JSON yang mungkin Anda dapatkan dari API MikroTik
    // (dengan beberapa data tambahan untuk UI kita).
    return {
      "ip-address": _ipAddress,
      "mac-address": _macAddress,
      "uptime": _formatUptime(uptime),
      "version": _version, // Firmware version
      "board-name": _boardName, // Device Model
      // Data di bawah ini tidak ada di API asli, kita tambahkan untuk UI
      "paket": _paket,
      "serial-number": _serialNumber,
      // Data traffic simulasi
      "simulated-tx": tx, // Upload in Mbps
      "simulated-rx": rx, // Download in Mbps
    };
  }

  // Di masa depan, Anda akan menambahkan metode lain di sini, seperti:
  // Future<List<dynamic>> getActiveUsers() async { ... }
  // Future<void> rebootDevice() async { ... }
}