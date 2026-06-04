// packages/service_shared/lib/src/firebase/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  // Constructor injection untuk fleksibilitas (bisa diisi MockFirebaseAuth saat test)
  AuthService({FirebaseAuth? firebaseAuth}) 
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  // Mendapatkan user yang sedang login (Stream)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login dengan Email & Password
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  User? get currentUser => _auth.currentUser;
}