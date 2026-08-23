
// Disimpan di layer controller / logic
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_services/shared_services.dart';

class AuthController {
  final AuthRemoteDataSource _dataSource = AuthRemoteDataSource();

  // Logika utama pemeriksaan izin matrix members
  Future<Map<String, dynamic>> processLoginValidation(String email, String password) async {
    try {
      UserCredential userCredential = await _dataSource.signInWithEmail(email, password);
      User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-found', message: 'Pengguna tidak ditemukan.');
      }

      String? uid = user.uid;
      var snapshot = await _dataSource.checkMemberPermission(uid);

      if (snapshot.exists) {
        Map<dynamic, dynamic> memberData = snapshot.value as Map<dynamic, dynamic>;
        bool isAllowed = memberData['isAllowed'] ?? false;
        String role = memberData['role'] ?? 'member';

        if (!isAllowed) {
          await _dataSource.signOut();
          throw FirebaseAuthException(code: 'access-denied', message: 'Akses Anda telah ditangguhkan oleh Admin.');
        }

        // Simpan token jika diizinkan
        String? token = await user.getIdToken();
        if (token != null) {
          await _dataSource.saveToken(token);
        }

        return {'success': true, 'role': role};
      } else {
        await _dataSource.signOut();
        throw FirebaseAuthException(code: 'access-denied', message: 'Akun Anda belum terdaftar di sistem Matrix.');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Email atau Password salah.';
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'access-denied':
        return e.message ?? 'Akun tidak memiliki izin.';
      case 'user-not-found':
        return 'Akun dengan email ini tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Coba lagi nanti.';
      default:
        return e.message ?? 'Autentikasi gagal.';
    }
  }
}