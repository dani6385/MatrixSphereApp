// packages/service_shared/lib/src/firebase/firebase_initializer.dart

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Mengambil dari file yang Anda miliki

class FirebaseInitializer {
  /// Memanggil ini di main.dart aplikasi Anda
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}