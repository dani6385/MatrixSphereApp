import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class VoucherService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('mikrotik/vouchers');

  Future<void> createVoucher(String code, String profile, int durationDays) async {
    final String id = const Uuid().v4();

    await _db.child(code).set({
      'id': id,
      'code': code,
      'profile': profile,
      'duration_days': durationDays,
      'used': false,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}