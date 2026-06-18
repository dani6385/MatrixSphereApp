import 'package:firebase_database/firebase_database.dart';

class HotspotUser {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Fungsi untuk mengambil data spesifik berdasarkan IP
  // Ini menghindari masalah karakter titik (.) pada path
  Query getActiveHosts(String identity, String ipAddress) {
    return _dbRef
        .child('mikrotik_data/$identity/active')
        .orderByChild('ip')
        .equalTo(ipAddress);
        
  }
}