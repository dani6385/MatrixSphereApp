class AppRoutes {
  static const String home = '/';
  static const String stream = '/stream';
  static const String management = '/management';
  static const String sellers = '/sellers';
  static const String attendance = '/attendance';
  static const String chat = '/chat';
  static const String products = '/products';
  static const String productDetail =
      '/products/:productId'; // Route with parameter
  // Rute baru untuk detail produk publik berdasarkan toko dan produk
  static const String publicProductDetail = '/shops/:shopId/products/:productId';
  static const String profile = '/profile';
  static const String editprofile = '/profile/edit';
  static const String publicProduct = '/products';
  static const String addProduct = '/products/add';
  static const String productEdit = '/products/:productId/edit';
  static const String login = '/login';
  static const String productDetailEdit = '/products/:productId/edit';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String settings = '/settings';
  static const String shopRegistration = '/shop-registration';
  
}
