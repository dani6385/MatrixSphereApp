// packages/service_shared/lib/src/firebase/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/firebase_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore}) 
      : _db = firestore ?? FirebaseFirestore.instance;

  // Contoh: Mengambil dokumen user
  Future<DocumentSnapshot> getUserDocument(String uid) async {
    return await _db.collection(FirestoreCollections.users).doc(uid).get();
  }

  // Contoh: Menambah atau update data
  Future<void> setUserData(String uid, Map<String, dynamic> data) async {
    await _db.collection(FirestoreCollections.users).doc(uid).set(
      data, 
      SetOptions(merge: true),
    );
  }

  // Contoh: Stream data dari collection (bagus untuk UI real-time)
  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }
}