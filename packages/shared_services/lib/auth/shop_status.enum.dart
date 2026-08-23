import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart'; // Anda memerlukan ini untuk tipe data Position

// Enum untuk merepresentasikan status toko, agar lebih aman dari typo.
enum ShopStatus {
  none,
  pending,
  approved,
  rejected,
}

class ShopService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Mendaftarkan toko baru dan menyimpannya di node 'shops_pending_approval'.
  ///
  /// Method ini akan membuat entri baru di bawah `shops_pending_approval/{ownerUid}`
  /// dengan status 'pending'. Ini sesuai dengan aturan RTDB Anda.
  Future<void> registerShop({
    required String ownerUid,
    required String shopName,
    required String pickupAddress,
    Position? coordinates, // Gunakan tipe data Position dari geolocator
  }) async {
    try {
      // 1. Tentukan path di database. Sesuai aturan, kita menulis ke 'shops_pending_approval'.
      final pendingShopRef = _dbRef.child('shops_pending_approval').child(ownerUid);

      // 2. Siapkan data yang akan dikirim. Strukturnya harus cocok dengan aturan validasi.
      final Map<String, dynamic> shopData = {
        'ownerUid': ownerUid,
        'shopName': shopName,
        'email': FirebaseAuth.instance.currentUser?.email ?? '', // Ambil email dari user auth
        'pickupAddress': pickupAddress,
        'pickupCoordinates': coordinates != null
            ? {
                'latitude': coordinates.latitude,
                'longitude': coordinates.longitude,
              }
            : null,
        'createdAt': ServerValue.timestamp, // Gunakan timestamp server untuk konsistensi
        'status': 'pending', // Status awal sesuai aturan RTDB
      };

      // 3. Tulis data ke database menggunakan .set()
      await pendingShopRef.set(shopData);
      
    } on FirebaseException catch (e) {
      // Tangani error spesifik dari Firebase (misal: permission denied)
      throw Exception('Gagal mendaftarkan toko: ${e.message}');
    } catch (e) {
      // Tangani error umum lainnya
      throw Exception('Terjadi kesalahan tidak terduga: ');
    }
  }

  /// Memeriksa status toko pengguna saat ini.
  ///
  /// Method ini digunakan oleh GoRouter untuk menentukan pengalihan (redirect).
  /// Ia akan memeriksa node 'seller_sphere' untuk mendapatkan shopId, lalu
  /// memeriksa status di node 'shops' atau 'shops_pending_approval'.
  Future<String?> getCurrentShopStatus(User? user) async {
    if (user == null) return null;

    try {
      // Cek dulu di 'shops_pending_approval'
      final pendingSnapshot = await _dbRef.child('shops_pending_approval').child(user.uid).get();
      if (pendingSnapshot.exists) {
        final data = pendingSnapshot.value as Map<dynamic, dynamic>?;
        // Jika ada, statusnya pasti 'pending' atau sedang diproses
        return data?['status'] as String? ?? ShopStatus.pending.name;
      }

      // Jika tidak ada di pending, cek di 'seller_sphere' untuk toko yang sudah disetujui
      final sellerSnapshot = await _dbRef.child('seller_sphere').child(user.uid).get();
      if (sellerSnapshot.exists) {
        // Jika ada data di seller_sphere, berarti tokonya sudah 'approved'.
        return ShopStatus.approved.name;
      }

      // Jika tidak ditemukan di mana pun, berarti pengguna belum mendaftarkan toko.
      return ShopStatus.none.name;

    } catch (e) {
      // Jika terjadi error, anggap saja belum ada toko untuk keamanan.
      print('Error saat memeriksa status toko: ');
      return null;
    }
  }
}
