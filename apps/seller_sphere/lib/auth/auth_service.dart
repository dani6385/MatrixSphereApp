import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Stream untuk memantau perubahan status otentikasi pengguna
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Fungsi Login
  Future<UserCredential> login(String email, String password) async {
    try {
      // Menggunakan Firebase Auth untuk login
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      // Menangani error umum
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  // Fungsi Register
  Future<UserCredential> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Simpan data tambahan pengguna (seperti nama) ke Realtime Database
      await _dbRef.child('sellers/${userCredential.user!.uid}').set({
        'name': name,
        'email': email,
        'createdAt': ServerValue.timestamp,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}