
import 'package:shared_ui/navigation/app_navigation.dart';

/// Implementasi AppNavigation spesifik untuk aplikasi Shop Sphere.
class ShopAppNavigation implements AppNavigation {
  // Gunakan konstanta statis untuk menghindari kesalahan ketik dan duplikasi.
  static const String _home = '/shop/home';
  static const String _login = '/shop/login';
  static const String _status = '/shop/status';

  @override
  String get homeScreen => _home;

  @override
  String get loginScreen => _login;

  @override
  String get statusScreen => _status;
}
