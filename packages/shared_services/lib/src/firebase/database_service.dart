// packages/service_shared/lib/src/firebase/database_service.dart

import 'package:firebase_database/firebase_database.dart';
import '../utils/firebase_constants.dart'; // Gunakan konstanta

class DatabaseService {
  final FirebaseDatabase _db;

  // Constructor injection untuk memudahkan testing
  DatabaseService({FirebaseDatabase? database}) 
      : _db = database ?? FirebaseDatabase.instance;

  // Mengambil stream data mikrotik
  Stream<DatabaseEvent> getMikrotikData() {
    return _db.ref(DatabasePaths.mikrotikData).onValue;
  }
}