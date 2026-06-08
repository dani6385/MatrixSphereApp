import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('member');

  // 1. Stream status login (Firebase Auth)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 2. Fungsi Login Khusus Member (Realtime Database)
  // Digunakan untuk validasi username & password dari DB
  Future<bool> loginMember(String user, String pass) async {
    try {
      final snapshot = await _dbRef.get();
      if (!snapshot.exists) return false;

      // Mengambil data dan melakukan pengecekan
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      
      // Memeriksa apakah ada entry yang cocok
      bool isMatch = data.values.any((m) => m['user'] == user && m['password'] == pass);
      
      return isMatch;
    } catch (e) {
      if (kDebugMode) {
        print("Error saat validasi member: $e");
      }
      return false;
    }
  }

  // 3. Fungsi Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}