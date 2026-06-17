import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class HotspotService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final Logger _logger = Logger();

  // Stream untuk mendengarkan data user yang sedang menunggu di Firebase
  Stream<DatabaseEvent> getWaitingUsersStream() {
    return _dbRef.child('mikrotik_data/MatrixSphere/wait').onValue;
  }

  // Fungsi untuk memicu Trial (misalnya mengubah status atau memindahkan data)
  Future<void> activateTrial(String macAddress, String username, String ip) async {
    final String waitPath = 'mikrotik_data/MatrixSphere/wait/$macAddress';
    final String activePath = 'mikrotik_data/MatrixSphere/active/$macAddress';
    Map<String, dynamic> updates = {};
    updates[activePath] = {
      'username': username,
      'ip': ip,
      'status': 'active',
      'activated_at': DateTime.now().toString(),
    };
    updates[waitPath] = null;
    await _dbRef.update(updates);
    try {
      // Logika: Pindahkan dari 'wait' ke 'active'
      // Atau sekadar kirim flag ke Mikrotik melalui Firebase
      await _dbRef.child('mikrotik_data/active/$macAddress').set({
        'status': 'aktif',
        'activated_at': DateTime.now().toString(),
      });

      // Hapus dari daftar tunggu
      await _dbRef
          .child('mikrotik_data/MatrixSphere/wait/$macAddress')
          .remove();

      _logger.i("Trial berhasil diaktifkan untuk $macAddress");
    } catch (e) {
      _logger.e("Error mengaktifkan trial: $e");
    }
  }
}
