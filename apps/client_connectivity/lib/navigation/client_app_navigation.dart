
import 'package:shared_ui/navigation/app_navigation.dart';

/// Implementasi AppNavigation spesifik untuk aplikasi Client Connectivity.
class ClientAppNavigation implements AppNavigation {
  // Gunakan konstanta statis untuk menghindari kesalahan ketik dan duplikasi.
  static const String _home = '/client/home';
  static const String _login = '/client/login';
  static const String _status = '/client/status';

  @override
  String get homeScreen => _home;

  @override
  String get loginScreen => _login;

  @override
  String get statusScreen => _status;
}
