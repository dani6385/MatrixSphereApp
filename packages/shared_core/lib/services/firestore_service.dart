import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Menambah atau Update data (set)
  Future<void> setData({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collectionPath).doc(documentId).set(data);
  }

  // 2. Mengambil satu dokumen berdasarkan ID
  Future<DocumentSnapshot> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    return await _db.collection(collectionPath).doc(documentId).get();
  }

  // 3. Mengambil semua data dari collection (List)
  Future<QuerySnapshot> getCollection(String collectionPath) async {
    return await _db.collection(collectionPath).get();
  }

  // 4. Update field tertentu saja (tanpa menimpa seluruh dokumen)
  Future<void> updateField({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collectionPath).doc(documentId).update(data);
  }

  // 5. Menghapus dokumen
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    await _db.collection(collectionPath).doc(documentId).delete();
  }

  // 6. Mendengarkan perubahan data secara realtime (Stream)
  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }
}