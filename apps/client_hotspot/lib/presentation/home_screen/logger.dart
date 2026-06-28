import 'package:logger/logger.dart';

/// Instance logger global yang bisa diakses dari mana saja di dalam aplikasi.
///
/// Logger ini dikonfigurasi untuk memberikan output yang jelas dan berwarna
/// di konsol debug, yang juga bisa ditangkap oleh logcat di Android.
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // Hanya tampilkan 1 method di stack trace
    errorMethodCount: 5, // Tampilkan 5 method untuk error
    lineLength: 80, // Lebar baris
    colors: true, // Gunakan warna
    printEmojis: true, // Tampilkan emoji untuk setiap level log
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Tampilkan timestamp
  ),
  // Level log minimum yang akan ditampilkan. Level.debug akan menampilkan semua log.
  level: Level.debug,
);