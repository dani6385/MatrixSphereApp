
import 'package:shared_ui/navigation/app_navigation.dart';

/// Implementasi AppNavigation spesifik untuk aplikasi Admin MikroTik.
class AdminAppNavigation implements AppNavigation {
  // Gunakan konstanta statis untuk menghindari kesalahan ketik dan duplikasi.
  static const String _home = '/admin/home';
  static const String _login = '/admin/login';
  static const String _status = '/admin/status';

  @override
  String get homeScreen => _home;

  @override
  String get loginScreen => _login;

  @override
  String get statusScreen => _status;
}
