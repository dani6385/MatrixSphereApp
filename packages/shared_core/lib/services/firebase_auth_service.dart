import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('member');

  // 1. Stream untuk memantau status login Firebase Auth
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 2. Fungsi Login untuk Member (RTDB)
  // Digunakan untuk mengecek kredensial custom di Realtime Database
  Future<bool> loginMember(String user, String pass) async {
    try {
      final snapshot = await _dbRef.get();
      if (!snapshot.exists) return false;

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      
      // Cek apakah ada member dengan user & password yang sesuai
      bool isMatch = data.values.any((m) => m['user'] == user && m['password'] == pass);
      
      return isMatch;
    } catch (e) {
      // ignore: avoid_print
      print("Error saat validasi member: $e");
      return false;
    }
  }

  // 3. Fungsi Login Resmi (Firebase Auth)
  // Gunakan jika Anda nantinya ingin menggunakan sistem login email/password bawaan Firebase
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (kDebugMode) {
        print("Error Firebase Auth: $e");
      }
      return null;
    }
  }

  // 4. Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}