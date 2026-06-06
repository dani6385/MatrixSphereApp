// packages/shared_services/lib/firebase/firebase_service.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  // Fungsi statis untuk inisialisasi Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD16fxrq8bRBiXYsRc9r6WTKaobYGakWTA",
        appId: "1:887909343137:web:187485f92032839b7275e0",
        messagingSenderId: "887909343137",
        projectId: "matrixsphere-build",
        authDomain: "matrixsphere-build.firebaseapp.com",
        databaseURL: "https://matrixsphere-build-default-rtdb.asia-southeast1.firebasedatabase.app",
        storageBucket: "matrixsphere-build.firebasestorage.app",
        measurementId: "G-BMRKN7L404",
      ),
    );
  }

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Fungsi untuk mendengarkan data baru secara realtime
  void listenToOrders(Function(Map<dynamic, dynamic>, String) onOrderReceived) {
    _dbRef.child('orders').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final key = event.snapshot.key!;
        
        // Panggil fungsi callback saat ada data baru
        if (data['status'] == 'pending') {
          onOrderReceived(data, key);
        }
      }
    });
  }

  // Fungsi untuk update status setelah sukses diproses
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _dbRef.child('orders/$orderId').update({'status': status});
  }
}