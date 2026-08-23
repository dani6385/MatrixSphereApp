// Disimpan di direktori: lib/controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Logika login dengan validasi matrix members
  Future<Map<String, dynamic>> validateAndLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? uid = userCredential.user?.uid;
      if (uid == null) {
        throw FirebaseAuthException(code: 'user-not-found', message: 'Pengguna tidak ditemukan.');
      }

      // Periksa izin akses di database matrix_members
      DatabaseEvent event = await _database.ref("matrix_members/$uid").once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> memberData = event.snapshot.value as Map<dynamic, dynamic>;

        bool isAllowed = memberData['isAllowed'] ?? false;
        String role = memberData['role'] ?? 'member';

        if (!isAllowed) {
          await _auth.signOut();
          throw FirebaseAuthException(
            code: 'access-denied',
            message: 'Akses Anda telah ditangguhkan oleh Admin.',
          );
        }

        return {'success': true, 'role': role};
      } else {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'access-denied',
          message: 'Akun Anda belum terdaftar di sistem Matrix.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(handleAuthError(e));
    } catch (e) {
      throw Exception('Email atau Password salah.');
    }
  }

  String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'access-denied':
        return e.message ?? 'Akun Anda tidak memiliki izin akses ke aplikasi Matrix Sphere.';
      case 'user-not-found':
        return 'Akun dengan email ini tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah. Silakan periksa kembali.';
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan oleh administrator.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Silakan coba lagi beberapa saat.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Pastikan perangkat terhubung ke internet.';
      case 'channel-error':
        return 'Mohon lengkapi email dan kata sandi Anda.';
      default:
        return e.message ?? 'Autentikasi gagal. Silakan coba lagi.';
    }
  }
}