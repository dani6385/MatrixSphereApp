import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:seller_sphere/models/shop_model.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class FirebaseRtdbService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Mendapatkan data toko secara real-time berdasarkan [userId].
  Stream<Shop?> getShopStreamByUid(String userId) {
    final shopRef = _dbRef.child('shops').child(userId);
    return shopRef.onValue.map((event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return Shop.fromMap(data);
      }
      return null;
    });
  }

  /// Membuat data toko baru di Realtime Database.
  /// ID toko akan sama dengan UID pengguna.
  Future<void> createShop(Shop shop) async {
    try {
      await _dbRef.child('shops').child(shop.id).set(shop.toMap());
    } catch (e) {
      // Anda bisa menambahkan logging atau error handling yang lebih baik di sini
      logger.e('Error creating shop: $e');
      rethrow;
    }
  }

  /// Memperbarui data toko yang sudah ada.
  Future<void> updateShop(Shop shop) async {
    await _dbRef.child('shops').child(shop.id).update(shop.toMap());
  }
}