import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// Provider untuk RegistrationNotifier
final registrationProvider = StateNotifierProvider.autoDispose<RegistrationNotifier, AsyncValue<void>>((ref) {
  return RegistrationNotifier();
});

// State Notifier untuk mengelola state pendaftaran
class RegistrationNotifier extends StateNotifier<AsyncValue<void>> {
  RegistrationNotifier() : super(const AsyncValue.data(null));

  Future<void> register({
    required String name,
    required String storeName,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Simulasi panggilan API ke backend untuk mendaftarkan pengguna
      logger.i('Mendaftarkan pengguna baru: $name ($email) dengan toko: $storeName');
      await Future.delayed(const Duration(seconds: 2));

      // Di aplikasi nyata, di sini Anda akan memanggil:
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // Lalu menyimpan data tambahan (nama, nama toko) ke Firestore atau database Anda.

      logger.i('Pengguna berhasil didaftarkan.');
      state = const AsyncValue.data(null);
    } catch (e, s) {
      logger.e('Gagal mendaftarkan pengguna', error: e, stackTrace: s);
      state = AsyncValue.error(e, s);
    }
  }
}
