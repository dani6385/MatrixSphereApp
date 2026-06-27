import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class FirestoreService {
  // Mendapatkan instance dari Cloud Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
      developer.log('User data saved successfully for $userId', name: 'FirestoreService');
    } catch (e, stackTrace) {
      developer.log(
        'Error saving user data to Firestore',
        name: 'FirestoreService',
        error: e,
        stackTrace: stackTrace,
        level: 1000, // SEVERE
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
        developer.log('User data successfully retrieved for $userId', name: 'FirestoreService');
        return doc;
      } else {
        developer.log('User document not found for $userId', name: 'FirestoreService', level: 800); // INFO
        return null;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error getting user data from Firestore',
        name: 'FirestoreService',
        error: e,
        stackTrace: stackTrace,
        level: 1000, // SEVERE
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
      developer.log('Successfully retrieved ${querySnapshot.docs.length} offers.', name: 'FirestoreService');
      return querySnapshot.docs;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting offers from Firestore',
        name: 'FirestoreService',
        error: e,
        stackTrace: stackTrace,
        level: 1000, // SEVERE
      );
      // Lemparkan kembali error agar provider bisa menanganinya
      rethrow;
    }
  }
}
