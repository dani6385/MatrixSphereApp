
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Mengambil stream data toko berdasarkan `shopId`.
  ///
  /// Mengembalikan `Stream<Map<String, dynamic>>` yang akan memancarkan
  /// data toko setiap kali ada perubahan di Firestore.
  Stream<Map<String, dynamic>?> getShopStream(String shopId) {
    return _firestore.collection('shops').doc(shopId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }
}