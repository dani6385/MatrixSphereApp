import 'package:flutter/material.dart';

/// Enum untuk merepresentasikan tipe perangkat.
enum DeviceType {
  mobile,
  tablet,
}

/// Provider untuk mengelola dan menyediakan informasi terkait perangkat.
///
/// Ini memungkinkan widget untuk beradaptasi dengan ukuran layar, orientasi,
/// dan tipe perangkat yang berbeda.
class DeviceProvider with ChangeNotifier {
  // Properti privat untuk menyimpan state
  Size _screenSize = Size.zero;
  DeviceType _deviceType = DeviceType.mobile;
  Orientation _orientation = Orientation.portrait;

  // Getter publik untuk mengakses state
  Size get screenSize => _screenSize;
  DeviceType get deviceType => _deviceType;
  Orientation get orientation => _orientation;
  bool get isMobile => _deviceType == DeviceType.mobile;
  bool get isTablet => _deviceType == DeviceType.tablet;

  /// Memperbarui metrik perangkat berdasarkan BuildContext saat ini.
  ///
  /// Panggil metode ini di widget level atas (misalnya, di dalam `build` method
  /// dari halaman utama) untuk memastikan data selalu terbaru.
  void updateDeviceMetrics(BuildContext context) {
    final newSize = MediaQuery.of(context).size;
    final newOrientation = MediaQuery.of(context).orientation;

    // Logika sederhana untuk menentukan tipe perangkat berdasarkan lebar terpendek.
    // Angka 600 adalah ambang batas umum.
    final newDeviceType =
        newSize.shortestSide < 600 ? DeviceType.mobile : DeviceType.tablet;

    // Hanya panggil notifyListeners jika ada perubahan untuk efisiensi.
    if (newSize != _screenSize ||
        newOrientation != _orientation ||
        newDeviceType != _deviceType) {
      _screenSize = newSize;
      _orientation = newOrientation;
      _deviceType = newDeviceType;
      notifyListeners();
    }
  }
}