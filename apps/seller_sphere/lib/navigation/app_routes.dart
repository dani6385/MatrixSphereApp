// lib/navigation/app_routes.dart

/// Kelas ini berisi semua konstanta path rute yang digunakan dalam aplikasi.
/// Menggunakan kelas ini membantu menghindari kesalahan ketik (typo) dan
/// memudahkan pengelolaan rute di satu tempat.
class AppRoutes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Shell Routes (dengan Bottom Nav Bar)
  static const String home = '/';
  static const String stream = '/stream';
  static const String management = '/management';
  static const String sellers = '/sellers';
  static const String attendance = '/attendance';

  // Top-Level Routes (Fullscreen)
  static const String profile = '/profile';
  static const String aditProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String chat = '/chat';
  static const String shopRegistration = '/shop-registration';

  // Products (bisa sebagai sub-route atau top-level)
  static const String publicProduct = '/products';
  static const String addProduct = '/products/add'; // sub-route: /products/add
  static const String productDetail = '/product-detail/:id';
  static const String productDetailEdit = '/products/:productId/edit';

  // Sub-routes untuk Attendance
  static const String attendanceOverview = '/attendance/overview';
  static const String attendancePunch = '/attendance/punch';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceReports = '/attendance/reports';
  static const String attendanceSettings = '/attendance/settings';

  // Sub-routes untuk Management
  static const String managementEdit = '/management/edit';
  static const String managementApproval = '/management/approval';
}