library shared_assets;
export 'src/theme_config.dart';

/// Kelas helper untuk menyimpan path aset agar tidak terjadi typo (salah ketik)
class AppAssets {
  // Path dasar untuk folder assets
  static const String _basePath = 'assets';

  // Contoh path gambar
  static const String logo = '$_basePath/images/logo.png';
  static const String background = '$_basePath/images/background.png';
  static const String userPlaceholder =
      '$_basePath/images/user_placeholder.png';

  // Contoh path ikon
  static const String iconSearch = '$_basePath/icons/search.svg';
  static const String iconUser = '$_basePath/icons/user.svg';

  // Nama package (Wajib digunakan di parameter `package` saat memanggil asset)
  static const String packageName = 'shared_assets';
}
