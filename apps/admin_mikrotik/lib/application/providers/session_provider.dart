import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_mikrotik/domain/entities/session_data.dart';

// 1. Definisikan State Notifier
class SessionDataNotifier extends StateNotifier<SessionData?> {
  // Inisialisasi state dengan data awal (bisa null atau data default)
  SessionDataNotifier() : super(null) {
    // Di aplikasi nyata, Anda akan memanggil metode untuk mengambil data dari API di sini.
    // Untuk saat ini, kita gunakan data hardcoded seperti sebelumnya.
    loadInitialData();
  }

  void loadInitialData() {
    state = const SessionData(
      username: 'John Doe',
      packageName: 'Premium Package',
      quotaUsedPercent: 0.75, // 75%
      quotaUsedMB: 768,
      quotaTotalMB: 1024,
      uptime: '1h 23m 45s',
      sessionTime: '0h 45m 12s',
      downloadSpeed: 1.2, // Mbps
      uploadSpeed: 0.8, // Mbps
      ipAddress: '192.168.1.100',
      macAddress: '00:1A:2B:3C:4D:5E',
      ssid: 'MySweetHomeWiFi',
      expiresAt: '2024-12-31 23:59',
    );
  }

  /// Method untuk memuat ulang data sesi.
  Future<void> refreshSessionData() async {
    // 1. Atur state menjadi null untuk menampilkan loading indicator di UI
    state = null;
    // 2. Simulasikan jeda jaringan
    await Future.delayed(const Duration(seconds: 1));
    // 3. Muat kembali data (di aplikasi nyata, ini akan memanggil API lagi)
    state = const SessionData(
      username: 'John Doe',
      packageName: 'Premium Package',
      quotaUsedPercent: 0.85,
      quotaUsedMB: 870,
      quotaTotalMB: 1024,
      uptime: '1h 55m 02s',
      sessionTime: '1h 12m 33s',
      downloadSpeed: 1.5,
      uploadSpeed: 0.9,
      ipAddress: '192.168.1.100',
      macAddress: '00:1A:2B:3C:4D:5E',
      ssid: 'MySweetHomeWiFi',
      expiresAt: '2024-12-31 23:59',
    );
  }

  /// Method untuk logout pengguna.
  void logout() {
    // Hapus data sesi dengan mengatur state ke null.
    // Di aplikasi nyata, Anda mungkin juga perlu menghapus token/session dari local storage di sini.
    state = null;
  }
}

// 2. Definisikan Provider global
final sessionDataProvider = StateNotifierProvider<SessionDataNotifier, SessionData?>((ref) {
  return SessionDataNotifier();
});
