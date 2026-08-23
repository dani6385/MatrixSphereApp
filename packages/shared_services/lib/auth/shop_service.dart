import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'shop_status.enum.dart'; // Impor enum yang sudah dipisah

class ShopService extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Mendaftarkan entri awal toko hanya dengan nama toko.[cite: 4]
  Future<void> createInitialShopEntry(
      {required User user, required String shopName}) async {
    try {
      final newShopRef = _dbRef.child('shops').push();
      final shopId = newShopRef.key;
      if (shopId == null) throw Exception("Gagal membuat ID toko unik.");

      final initialShopData = {
        'ownerUid': user.uid,
        'shopName': shopName,
        'email': user.email,
        'createdAt': ServerValue.timestamp,
      };

      // Menggunakan multi-path update untuk memastikan operasi atomik
      await _dbRef.update({
        'shops/$shopId': initialShopData,
        'seller_sphere/${user.uid}': {
          'shopId': shopId,
          'shopName': shopName,
          'email': user.email,
          'createdAt': ServerValue.timestamp,
        },
      });
      notifyListeners(); // Memberi notifikasi jika ada listener yang memantau perubahan
    } catch (e) {
      await user.delete();
      throw Exception('Gagal membuat entri toko awal: $e');
    }
  }

  /// Memperbarui detail toko dengan alamat dan koordinat.
  Future<void> updateShopDetails({
    required String token,
    required String userId,
    required String shopId,
    required String fullAddress,
    required Map<String, dynamic> coordinates,
  }) async {
    try {
      final Map<String, dynamic> detailsData = {
        'pickupAddress': fullAddress, // Path: /pickupAddress
        'pickupCoordinates': coordinates, // Path: /pickupCoordinates
      };

      // Menggunakan multi-path update untuk konsistensi
      await _dbRef.update({
        'shops/$shopId/pickupAddress': detailsData['pickupAddress'],
        'shops/$shopId/pickupCoordinates': detailsData['pickupCoordinates'],
        'seller_sphere/$userId/pickupAddress': detailsData['pickupAddress'],
        'seller_sphere/$userId/pickupCoordinates':
            detailsData['pickupCoordinates'],
      });
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mendaftarkan toko: $e');
    }
  }

  /// Mengambil data lengkap seller dari node 'sellers'.[cite: 4]
  Future<Map<String, dynamic>?> getSellerData(String uid) async {
    try {
      final snapshot = await _dbRef.child('seller_sphere/$uid').get();
      if (snapshot.exists && snapshot.value != null) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data seller: $e');
    }
  }

  /// Mengambil shopId yang aktif.[cite: 4]
  Future<String?> getCurrentShopId(User? currentUser) async {
    if (currentUser == null) {
      return 'toko_percobaan';
    }

    try {
      final snapshot =
          await _dbRef.child('seller_sphere/${currentUser.uid}/shopId').get();
      if (snapshot.exists) {
        return snapshot.value as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil shopId: $e');
    }
  }

  /// Memeriksa status toko pengguna.[cite: 4]
  Future<ShopStatus> getUserShopStatus(User? currentUser) async {
    if (currentUser == null) return ShopStatus.none;

    final uid = currentUser.uid;
    try {
      final sellerSnapshot = await _dbRef.child('seller_sphere/$uid').get();
      if (sellerSnapshot.exists) return ShopStatus.approved;

      final approvalSnapshot = await _dbRef.child('approval/$uid').get();
      if (approvalSnapshot.exists) return ShopStatus.pending;
    } catch (e) {
      // Abaikan error[cite: 4]
    }
    return ShopStatus.none;
  }

  /// Mendaftarkan toko baru dan menempatkannya dalam status 'pending approval'.[cite: 4]
  Future<void> registerShop(
      {required User user,
      required String shopName,
      required String fullAddress,
      required Map<String, double> coordinates}) async {
    try {
      final shopData = {
        'ownerUid': user.uid,
        'shopName': shopName,
        'email': user.email,
        'pickupAddress': fullAddress,
        'pickupCoordinates': coordinates,
        'createdAt': ServerValue.timestamp,
        'status': 'pending',
      };

      await _dbRef.child('shops_pending_approval/${user.uid}').set(shopData);
      notifyListeners();
    } catch (e) {
      await user.delete();
      throw Exception('Gagal mendaftarkan toko: $e');
    }
  }
}
