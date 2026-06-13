import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

/// Kelas FirebaseService bertanggung jawab untuk menginisialisasi
/// dan menyediakan akses dasar ke fungsionalitas Firebase.
///
/// Ini adalah kelas inti yang harus diinisialisasi saat aplikasi dimulai.
class FirebaseService {
  final Logger _logger = Logger();

  /// Menginisialisasi koneksi Firebase.
  ///
  /// Harus dipanggil di `main.dart` sebelum `runApp()`.
  /// Menerima [FirebaseOptions] yang spesifik untuk setiap platform (Android, iOS, Web).
  Future<void> initialize({required FirebaseOptions options}) async {
    try {
      await Firebase.initializeApp(options: options);
      _logger.i('Firebase successfully initialized!');
    } catch (e) {
      _logger.e('Firebase initialization failed: $e');
      // Melempar kembali error agar bisa ditangani di level aplikasi jika perlu
      rethrow;
    }
  }
}
