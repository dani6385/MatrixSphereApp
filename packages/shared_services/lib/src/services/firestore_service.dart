// packages/shared_services/lib/src/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> logVoucherCreation(String name, String profile) async {
    await _db.collection('voucher_logs').add({
      'username': name,
      'profile': profile,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
