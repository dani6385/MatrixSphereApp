
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

class HotspotService {
  final DatabaseReference _waitRef = FirebaseDatabase.instance.ref('mikrotik_data/MatrixSphere/wait');
  final Logger _logger = Logger();
  final NetworkInfo _networkInfo = NetworkInfo();

  /// Fetches the MAC address for the current device's IP from RTDB.
  ///
  /// This function will:
  /// 1. Get the device's local WiFi IP address.
  /// 2. Look for an entry in the RTDB 'wait' node matching the IP.
  ///    (Note: It assumes the IP's dots are replaced with underscores, e.g., "192.168.30.5" -> "192_168_30_5").
  /// 3. Extract the 'mac' value from the data.
  /// 4. Delete the RTDB entry after successful retrieval.
  ///
  /// - Returns the MAC address [String] on success.
  /// - Returns `null` if the IP cannot be determined, no entry is found,
  ///   or the data format is incorrect.
  Future<String?> fetchAndClearMacAddress() async {
    try {
      // 1. Dapatkan Alamat IP WiFi perangkat
      final String? ip = await _networkInfo.getWifiIP();
      if (ip == null) {
        _logger.w("Tidak bisa mendapatkan IP WiFi. Apakah perangkat terhubung ke WiFi?");
        return null;
      }
      _logger.i("IP WiFi perangkat: $ip");

      // 2. Ganti '.' dengan '_' agar menjadi key Firebase yang valid
      final String ipKey = ip.replaceAll('.', '_');
      final DatabaseReference ipNodeRef = _waitRef.child(ipKey);

      // 3. Baca data satu kali dari node IP yang spesifik
      final DataSnapshot snapshot = await ipNodeRef.get();

      if (!snapshot.exists || snapshot.value == null) {
        _logger.w("Tidak ada data MAC yang ditemukan di RTDB untuk kunci IP: $ipKey. Menunggu Mikrotik untuk mengunggah data...");
        return null;
      }

      // 4. Ekstrak MAC address dari data
      // Mengasumsikan Mikrotik mengirim data seperti: { 'mac': 'XX:XX:XX:XX:XX:XX' }
      final data = snapshot.value as Map<dynamic, dynamic>;
      final String? mac = data['mac'];

      if (mac == null) {
        _logger.e("Data ditemukan untuk IP $ipKey, tapi tidak mengandung field 'mac'. Data: $data");
        return null;
      }
      _logger.i("Berhasil mendapatkan MAC address: $mac untuk IP: $ip");

      // 5. Hapus entri dari RTDB setelah berhasil dibaca
      await ipNodeRef.remove();
      _logger.i("Entri untuk $ipKey telah dihapus dari node 'wait'.");

      return mac;

    } catch (e) {
      _logger.e("Terjadi error saat mengambil MAC dari RTDB: $e");
      return null;
    }
  }
}
