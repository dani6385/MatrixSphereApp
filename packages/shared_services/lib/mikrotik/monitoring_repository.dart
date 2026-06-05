import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini!

class MonitoringDashboard {
  final Stream<DocumentSnapshot> statsStream;
  final List<Map<String, dynamic>> interfaces;
  final bool isLoading;

  const MonitoringDashboard({
    required this.statsStream,
    required this.interfaces,
    required this.isLoading,
  });
}

// packages/shared_services/lib/src/mikrotik/monitoring_repository.dart
class MonitoringRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream data dari Firebase
  Stream<DocumentSnapshot> getMikrotikStatsStream() {
    return _db.collection('mikrotik_stats').doc('current').snapshots();
  }

  // Logika fetch interface
  Future<List<Map<String, dynamic>>> getInterfaces() async {
    // Logika API MikroTik Anda di sini
    return [];
  }
}
