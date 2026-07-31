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
  Future<UserCredential> register(String shopName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user == null) {
        throw Exception("Gagal membuat pengguna, data pengguna tidak ditemukan.");
      }

      // 1. Buat entri baru di node 'shops' untuk mendapatkan shopId unik
      final newShopRef = _dbRef.child('shops').push();
      final shopId = newShopRef.key;

      // 2. Siapkan data untuk ditulis ke database
      final Map<String, dynamic> shopData = {
        'ownerUid': user.uid,
        'shopName': shopName,
        'email': email,
        'createdAt': ServerValue.timestamp,
      };

      // 3. Lakukan multi-path update untuk konsistensi data
      await _dbRef.update({
        'shops/$shopId': shopData, // Buat data toko baru
        'sellers/${user.uid}': {...shopData, 'shopId': shopId}, // Simpan referensi shopId di data seller
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  // Fungsi Kirim Email Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}