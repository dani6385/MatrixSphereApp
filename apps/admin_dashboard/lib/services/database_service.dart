import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Mengambil stream data untuk Admin
  Stream<DatabaseEvent> getMikrotikData() {
    return _dbRef.child('mikrotik_data').onValue;
  }
}