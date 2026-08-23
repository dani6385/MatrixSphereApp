/// File terpusat untuk mengelola semua API key dan variabel environment.
///
/// Menggunakan `String.fromEnvironment` memungkinkan kita untuk menyuntikkan nilai-nilai ini
/// saat kompilasi menggunakan flag `--dart-define`. Ini adalah praktik yang aman dan fleksibel.
class ApiConstants {
  /// Kunci API untuk Google Maps.
  ///
  /// Nilai ini diisi secara dinamis saat proses build berdasarkan platform target.
  /// Contoh: `flutter build apk --dart-define=GOOGLE_MAPS_API_KEY=KEY_ANDROID_ANDA`
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '', // Nilai default kosong untuk keamanan
  );

  /// Kunci API untuk layanan upload gambar ImgBB.
  ///
  /// Diambil dari variabel environment 'IMGBB_API_KEY'.
  /// Contoh: `flutter run --dart-define=IMGBB_API_KEY=KEY_IMGBB_ANDA`
  static const String imgbbApiKey = String.fromEnvironment(
    'IMGBB_API_KEY',
    defaultValue: '',
  );

  /// Kunci API default untuk layanan streaming.
  ///
  /// Diambil dari variabel environment 'DEFAULT_STREAM_KEY'.
  static const String defaultStreamKey = String.fromEnvironment(
    'DEFAULT_STREAM_KEY',
    defaultValue: '',
  );
}