// Opsional, untuk @required jika diperlukan

/// Model entitas untuk merepresentasikan pengguna atau pelanggan.
///
/// Digunakan di seluruh aplikasi untuk memastikan konsistensi data pengguna.
class User {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  const User({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
  });

  // Anda bisa menambahkan metode fromJson/toJson di sini jika diperlukan untuk serialisasi.
}