import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';


class FirestoreService {
  // Mendapatkan instance dari Cloud Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger(); // Buat satu instance untuk kelas ini

  /// Menambahkan atau memperbarui data pengguna di koleksi 'users'.
  ///
  /// [userId] adalah ID unik untuk pengguna (misalnya, dari Firebase Auth).
  /// [data] adalah Map yang berisi data pengguna (misalnya, nama, email).
  Future<void> setUserData(String userId, Map<String, dynamic> data) async {
    try {
      // Menggunakan .doc(userId) untuk menunjuk ke dokumen spesifik.
      // Menggunakan .set(data) untuk menulis data. Jika dokumen sudah ada, ia akan diperbarui.
      // Jika belum ada, dokumen baru akan dibuat.
      await _db.collection('users').doc(userId).set(data, SetOptions(merge: true));
      _logger.i('User data saved successfully for $userId');
    } catch (e, stackTrace) {
      _logger.e(
        'Error saving user data to Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      // Lemparkan kembali error agar UI bisa menanganinya jika perlu
      rethrow;
    }
  }

  /// Mengambil data pengguna dari Firestore.
  ///
  /// [userId] adalah ID pengguna yang datanya ingin diambil.
  /// Mengembalikan `DocumentSnapshot` yang berisi data pengguna jika ada.
  Future<DocumentSnapshot?> getUserData(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        _logger.i('User data successfully retrieved for $userId');
        return doc;
      } else {
        _logger.w('User document not found for $userId');
        return null;
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Error getting user data from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Mengambil semua dokumen dari koleksi 'offers'.
  ///
  /// Mengembalikan `List<QueryDocumentSnapshot>` yang berisi semua penawaran.
  Future<List<QueryDocumentSnapshot>> getOffers() async {
    try {
      final querySnapshot = await _db.collection('offers').orderBy('order', descending: false).get();
      _logger.i('Successfully retrieved ${querySnapshot.docs.length} offers.');
      return querySnapshot.docs;
    } catch (e, stackTrace) {
      _logger.e(
        'Error getting offers from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      // Lemparkan kembali error agar provider bisa menanganinya
      rethrow;
    }
  }

  /// Menambahkan dokumen pendaftaran seller baru ke koleksi 'seller_registrations'.
  ///
  /// [data] adalah Map yang berisi data dari formulir pendaftaran.
  /// Metode ini akan secara otomatis menambahkan status 'pending' dan tanggal registrasi.
  Future<void> addSellerRegistration(Map<String, dynamic> data) async {
    try {
      final registrationData = {
        ...data,
        'status': 'pending', // Status awal pendaftaran
        'registrationDate': FieldValue.serverTimestamp(), // Timestamp dari server
      };
      await _db.collection('seller_registrations').add(registrationData);
      _logger.i('Seller registration data saved successfully.');
    } catch (e, stackTrace) {
      _logger.e(
        'Error saving seller registration to Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Mengambil semua dokumen dari koleksi 'seller_registrations'.
  Future<List<QueryDocumentSnapshot>> getSellerRegistrations() async {
    try {
      final querySnapshot = await _db.collection('seller_registrations').get();
      _logger.i(
          'Successfully retrieved ${querySnapshot.docs.length} seller registrations.');
      return querySnapshot.docs;
    } catch (e, stackTrace) {
      _logger.e(
        'Error getting seller registrations from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Memperbarui status dokumen pendaftaran seller.
  ///
  /// [docId] adalah ID dokumen di koleksi 'seller_registrations'.
  /// [data] adalah Map yang berisi field yang akan diperbarui (misal: 'status', 'rejectionReason').
  Future<void> updateSellerRegistration(
      String docId, Map<String, Object> data) async {
    try {
      await _db.collection('seller_registrations').doc(docId).update(data);
      _logger.i('Seller registration $docId updated successfully.');
    } catch (e, stackTrace) {
      _logger.e(
        'Error updating seller registration $docId',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
