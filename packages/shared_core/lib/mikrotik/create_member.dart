import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

final logger = Logger();

class MemberService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("members");

  Future<void> createMember(String username, String password, String profile) async {
    final String id = const Uuid().v4();
    try {
      await _dbRef.child(username).set({
        "password": password,
        "profile": profile,
        "status": "active",
        "createdAt": DateTime.now().toIso8601String(),
      });
      logger.i("Member $username berhasil dibuat.");
    } catch (e) {
      logger.e("Gagal membuat member: $e");
    }
  }
}