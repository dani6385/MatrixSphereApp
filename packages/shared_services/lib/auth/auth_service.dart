<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Stream untuk memantau perubahan status otentikasi pengguna
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Fungsi Login
  Future<UserCredential> login(String email, String password) async {
    try {
      // Menggunakan Firebase Auth untuk login
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      // Menangani error umum
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  /// Fungsi Register - Hanya membuat akun pengguna di Firebase Authentication.
  Future<UserCredential> createUserAccount(String email, String password) async {
    try {
      final userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  /// Mendaftarkan detail toko ke Realtime Database setelah pengguna dibuat.
  Future<void> registerShop(
      {required User user, required String shopName}) async {
    try {
      // 1. Buat entri baru di node 'shops' untuk mendapatkan shopId unik
      final newShopRef = _dbRef.child('shops').push();
      final shopId = newShopRef.key;

      if (shopId == null) {
        throw Exception("Gagal membuat ID toko unik.");
      }

      // 2. Siapkan data untuk ditulis ke database
      final Map<String, dynamic> shopData = {
        'ownerUid': user.uid,
        'shopName': shopName,
        'email': user.email,
        'createdAt': ServerValue.timestamp,
      };

      // 3. Lakukan multi-path update untuk konsistensi data
      await _dbRef.update({
        'shops/$shopId': shopData, // Buat data toko baru
        'sellers/${user.uid}': {...shopData, 'shopId': shopId}, // Simpan referensi shopId di data seller
      });
    } catch (e) {
      // Jika pendaftaran toko gagal, hapus pengguna yang baru dibuat untuk konsistensi
      await user.delete();
      throw Exception('Gagal mendaftarkan toko: $e');
    }
  }

  // Fungsi Kirim Email Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
  
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Enum untuk merepresentasikan status toko pengguna.
enum ShopStatus { none, pending, approved }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Stream untuk memantau perubahan status otentikasi pengguna
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Fungsi Login
  Future<UserCredential> login(String email, String password) async {
    try {
      // Menggunakan Firebase Auth untuk login
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      // Menangani error umum
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  /// Fungsi Register - Hanya membuat akun pengguna di Firebase Authentication.
  Future<UserCredential> createUserAccount(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  /// Mendaftarkan entri awal toko hanya dengan nama toko.
  /// Ini akan membuat shopId dan menempatkan toko dalam status 'none' atau 'pending_details'.
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
        // Alamat dan koordinat akan ditambahkan nanti
      };

      await _dbRef.update({
        'shops/$shopId': initialShopData,
        'seller_sphere/${user.uid}': {'shopId': shopId, ...initialShopData},
      });
    } catch (e) {
      await user.delete(); // Rollback: hapus user jika pembuatan toko gagal
      throw Exception('Gagal membuat entri toko awal: $e');
    }
  }

  /// Memperbarui detail toko dengan alamat dan koordinat.
  Future<void> updateShopDetails(
      {required String uid,
      required String shopId,
      required String fullAddress,
      required Map<String, double> coordinates}) async {
    try {
      final Map<String, dynamic> detailsData = {
        'pickupAddress': fullAddress,
        'pickupCoordinates': coordinates,
      };

      // Lakukan multi-path update untuk konsistensi data
      await _dbRef.update({
        'shops/$shopId/': detailsData,
        'seller_sphere/$uid/': detailsData,
      });
    } catch (e) {
      // Jika pendaftaran toko gagal, hapus pengguna yang baru dibuat untuk konsistensi
      throw Exception('Gagal mendaftarkan toko: $e');
    }
  }

  /// Mengambil data lengkap seller dari node 'sellers'.
  Future<Map<String, dynamic>?> getSellerData(String uid) async {
    try {
      final snapshot = await _dbRef.child('seller_sphere/$uid').get();
      if (snapshot.exists && snapshot.value != null) {
        // Firebase mengembalikan data sebagai Map<Object?, Object?>
        // jadi kita perlu mengonversinya ke Map<String, dynamic>
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data seller: $e');
    }
  }

  /// Mengambil shopId yang aktif.
  /// - Jika pengguna login, akan mengambil shopId dari database.
  /// - Jika tidak ada pengguna yang login (mode percobaan), akan mengembalikan ID toko percobaan.
  /// - Mengembalikan `null` jika pengguna login tapi tidak punya shopId.
  Future<String?> getCurrentShopId() async {
    final user = currentUser;
    if (user == null) {
      // Mode Percobaan: Tidak ada pengguna yang login, kembalikan ID toko default.
      return 'toko_percobaan';
    }

    try {
      final snapshot =
          await _dbRef.child('seller_sphere/${user.uid}/shopId').get();
      if (snapshot.exists) {
        return snapshot.value as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil shopId: $e');
    }
  }

  /// Memeriksa status toko pengguna (approved, pending, atau tidak ada).
  Future<ShopStatus> getUserShopStatus() async {
    final user = currentUser;
    if (user == null) {
      return ShopStatus.none;
    }
    final uid = user.uid;

    try {
      // 1. Cek apakah toko sudah disetujui dan ada di 'sellers'
      final sellerSnapshot = await _dbRef.child('seller_sphere/$uid').get();
      if (sellerSnapshot.exists) {
        return ShopStatus.approved;
      }

      // 2. Jika tidak, cek apakah pendaftaran sedang dalam proses 'approval'
      final approvalSnapshot = await _dbRef.child('approval/$uid').get();
      if (approvalSnapshot.exists) {
        return ShopStatus.pending;
      }
    } catch (e) {
      // Abaikan error dan anggap tidak ada toko jika gagal fetch
    }
    // 3. Jika tidak ada di keduanya, berarti pengguna belum mendaftarkan toko
    return ShopStatus.none;
  }

  // Fungsi Kirim Email Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Mendaftarkan toko baru dan menempatkannya dalam status 'pending approval'.
  /// Fungsi ini menggantikan `createInitialShopEntry` dan `registerShop` yang kosong.
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
        'status': 'pending', // Status awal
      };

      // Simpan data pendaftaran ke node 'shops_pending_approval'
      // Admin akan memproses data dari node ini.
      await _dbRef.child('shops_pending_approval/${user.uid}').set(shopData);
    } catch (e) {
      // Jika gagal menyimpan data toko, hapus akun yang baru dibuat (rollback).
      await user.delete();
      throw Exception('Gagal mendaftarkan toko: $e');
    }
  }
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
