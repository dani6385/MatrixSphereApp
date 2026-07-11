import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import '../models/app_access.dart';
import '../models/notification.dart' as model;
import '../models/seller.dart';
import '../models/approval_request.dart';
import '../models/user_profile.dart';
import '../models/system_user.dart';
import 'package:intl/intl.dart';

enum LoginStep {
  loginSelection,
  googleSelect,
  verifying,
  twoFactor,
  loggedIn,
}

class AppViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;

  // --- STATE --- //
  bool _isLoggedIn = false;
  UserProfile? _currentUser;
  LoginStep _loginStep = LoginStep.loginSelection;
  String _twoFactorCode = "";
  String? _authError;
  String? _profileSuccessMessage;
  String _activeChatBuyerName = "";

  final otpController = TextEditingController();

  final List<AppAccess> _appAccessList = [];
  List<Seller> _sellers = [];
  List<ApprovalRequest> _approvalRequests = [];
  List<model.Notification> _notifications = [];
  final List<SystemUser> _systemUsers = [];
  List<dynamic> _products = [];
  List<dynamic> _transactions = [];
  dynamic _todayTarget;
  List<ShopsphereOrder> _shopsphereOrders = [];

  StreamSubscription? _sellersSubscription;
  StreamSubscription? _notificationsSubscription;
  StreamSubscription? _approvalsSubscription;
  StreamSubscription? _systemUsersSubscription;

  String _sellerSearchQuery = "";
  String _sellerFilterStatus = "Semua";

  // --- GETTERS ---
  bool get isLoggedIn => _isLoggedIn;
  UserProfile? get currentUser => _currentUser;
  LoginStep get loginStep => _loginStep;
  String get twoFactorCode => _twoFactorCode;
  String? get authError => _authError;
  String? get profileSuccessMessage => _profileSuccessMessage;
  String get sellerFilterStatus => _sellerFilterStatus;
  List<dynamic> get products => _products;
  List<dynamic> get lowStockProducts => _products.where((p) => p['stock'] < 5).toList();
  List<dynamic> get transactions => _transactions;
  dynamic get todayTarget => _todayTarget;
  List<ShopsphereOrder> get shopsphereOrders => _shopsphereOrders;
  String get activeChatBuyerName => _activeChatBuyerName;

  set activeChatBuyerName(String name) {
    _activeChatBuyerName = name;
    notifyListeners();
  }

  List<AppAccess> get appAccessList => _appAccessList;
  List<model.Notification> get notifications => _notifications.reversed.toList();
  List<SystemUser> get systemUsers => _systemUsers;
  List<Seller> get bannedSellers => _sellers.where((s) => s.isBanned).toList();

  List<Seller> get sellers {
    return _sellers.where((s) {
      final statusMatch =
          _sellerFilterStatus == "Semua" || s.status == _sellerFilterStatus;
      final queryMatch = _sellerSearchQuery.isEmpty ||
          s.name.toLowerCase().contains(_sellerSearchQuery.toLowerCase()) ||
          s.storeName.toLowerCase().contains(_sellerSearchQuery.toLowerCase());
      return statusMatch && queryMatch;
    }).toList();
  }

  List<ApprovalRequest> get approvalRequests =>
      _approvalRequests.where((r) => r.status == "Menunggu").toList();
  List<ApprovalRequest> get processedRequests =>
      _approvalRequests.where((r) => r.status != "Menunggu").toList();

  AppViewModel(this._firestoreService) {
    _initializeDataStreams();
    _loadMockData();
  }
  
  void _loadMockData() {
    _products = List.generate(20, (i) => {'name': 'Product $i', 'stock': i + 1});
    _transactions = List.generate(5, (i) => {'total': (i + 1) * 10000.0, 'profit': (i + 1) * 2000.0, 'timestamp': DateTime.now().millisecondsSinceEpoch});
    _todayTarget = {'targetAmount': 1500000.0};
    _shopsphereOrders = [
      ShopsphereOrder(id: "SS-2405-1A", customerName: "Budi", productName: "Kopi Lokal", quantity: 2, totalAmount: 50000, courierPhone: "08123456789", verificationCode: "123456", status: "Siap Diambil", dayIndex: 6),
      ShopsphereOrder(id: "SS-2405-2B", customerName: "Ani", productName: "Teh Impor", quantity: 1, totalAmount: 75000, courierPhone: "08987654321", verificationCode: "654321", status: "Perlu Dipacking", dayIndex: 6),
      ShopsphereOrder(id: "SS-2405-3C", customerName: "Caca", productName: "Susu Segar", quantity: 3, totalAmount: 45000, courierPhone: "08111222333", verificationCode: "112233", status: "Selesai Diambil", dayIndex: 5),
    ];
    notifyListeners();
  }

  void _initializeDataStreams() {
    _sellersSubscription = _firestoreService.getSellers().listen((snapshot) {
      _sellers = snapshot.docs.map((doc) => Seller.fromFirestore(doc)).toList();
      notifyListeners();
    });

    _notificationsSubscription = _firestoreService.getNotifications().listen((
      snapshot,
    ) {
      _notifications = snapshot.docs
          .map((doc) => model.Notification.fromFirestore(doc))
          .toList();
      notifyListeners();
    });

    _approvalsSubscription = _firestoreService.getApprovalRequests().listen((
      snapshot,
    ) {
      _approvalRequests = snapshot.docs
          .map((doc) => ApprovalRequest.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
    
    // _systemUsersSubscription = _firestoreService.getSystemUsers().listen((snapshot) {
    //   _systemUsers = snapshot.docs.map((doc) => SystemUser.fromFirestore(doc)).toList();
    //   notifyListeners();
    // });
  }

  @override
  void dispose() {
    _sellersSubscription?.cancel();
    _notificationsSubscription?.cancel();
    _approvalsSubscription?.cancel();
    _systemUsersSubscription?.cancel();
    otpController.dispose();
    super.dispose();
  }
  
  String formatRupiah(double amount) {
      final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return format.format(amount);
  }
  
  double getTodaySalesTotal() {
      final todayStart = DateTime.now().subtract(const Duration(hours: 24));
      return _transactions.where((t) => DateTime.fromMillisecondsSinceEpoch(t['timestamp']).isAfter(todayStart)).fold(0.0, (sum, t) => sum + t['total']);
  }

  void loadTodayTarget() {
    // In a real app, this would load from a persistent source.
    // For now, it's loaded in _loadMockData
    notifyListeners();
  }
  
  void updateTodayTarget(double amount) {
    _todayTarget = {'targetAmount': amount};
    notifyListeners();
  }
  
  void confirmOrderPickup(String orderId) {
    final index = _shopsphereOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _shopsphereOrders[index] = ShopsphereOrder(id: _shopsphereOrders[index].id, customerName: _shopsphereOrders[index].customerName, productName: _shopsphereOrders[index].productName, quantity: _shopsphereOrders[index].quantity, totalAmount: _shopsphereOrders[index].totalAmount, courierPhone: _shopsphereOrders[index].courierPhone, verificationCode: _shopsphereOrders[index].verificationCode, status: "Selesai Diambil", dayIndex: _shopsphereOrders[index].dayIndex);
      notifyListeners();
    }
  }
  
  void finishPacking(String orderId) {
    final index = _shopsphereOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _shopsphereOrders[index] = ShopsphereOrder(id: _shopsphereOrders[index].id, customerName: _shopsphereOrders[index].customerName, productName: _shopsphereOrders[index].productName, quantity: _shopsphereOrders[index].quantity, totalAmount: _shopsphereOrders[index].totalAmount, courierPhone: _shopsphereOrders[index].courierPhone, verificationCode: _shopsphereOrders[index].verificationCode, status: "Siap Diambil", dayIndex: _shopsphereOrders[index].dayIndex);
      notifyListeners();
    }
  }
  
  void callCourier(String orderId) {
    // In a real app, this would trigger a phone call
    print("Calling courier for order $orderId");
  }

  void printOrderLabel(String orderId) {
    // In a real app, this would connect to a printer
    print("Printing label for order $orderId");
  }

  void approveRequest(String id) {
    _firestoreService.updateApprovalStatus(id, "Disetujui");
  }

  void rejectRequest(String id) {
    _firestoreService.updateApprovalStatus(id, "Ditolak");
  }

  void simulateRandomSellerActivity() {
    // Implement this method
  }

  void toggleAppBlock(String appId) {
    // Implement this method
  }

  void addAppToMonitor(String appName) {
    // Implement this method
  }

  void banSeller(String id, String reason) {
    final seller = _sellers.firstWhere((s) => s.id == id);
    _firestoreService.updateSellerBanStatus(id, true, reason).then((_) {
      _addNotification(
        "AKUN DIBANNED: Toko '${seller.storeName}' ditangguhkan karena $reason.",
      );
    });
  }

  void unbanSeller(String id) {
    final seller = _sellers.firstWhere((s) => s.id == id);
    _firestoreService.updateSellerBanStatus(id, false, null).then((_) {
      _addNotification(
        "AKUN DIPULIHKAN: Blokir toko '${seller.storeName}' telah dicabut admin.",
      );
    });
  }

  void deleteSeller(String id) {
    // _firestoreService.deleteSeller(id);
  }

  void addNewSeller(Map<String, String> sellerData) {
    // _firestoreService.addSeller(sellerData);
  }


  void dismissNotification(String id) {
    _firestoreService.markNotificationAsRead(id);
  }

  void markAllNotificationsAsRead() {
    _firestoreService.markAllNotificationsAsRead();
  }

  void _addNotification(String message) {
    _firestoreService.insertNotification({'message': message});
  }

  void initiateGoogleLogin() {
    _loginStep = LoginStep.googleSelect;
    notifyListeners();
  }

  Future<void> selectGoogleAccount(String email) async {
    _loginStep = LoginStep.verifying;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));

    final username = email.split('@').first;
    _currentUser = UserProfile(
      id: 'google-user',
      username: username,
      fullName: "${username[0].toUpperCase()}${username.substring(1)} (Google)",
      email: email,
      phone: "+62812${Random().nextInt(99999999)}",
      passwordHash: "google_oauth_token",
      isTwoFactorEnabled: true, // 2FA aktif untuk akun Google
    );

    _startTwoFactorAuth();
  }

  Future<void> performTraditionalLogin(String username, String password) async {
    _loginStep = LoginStep.verifying;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));

    if (username == 'admin' && password == 'admin') {
      _currentUser = UserProfile(
        id: 'admin-user',
        username: "admin",
        fullName: "Administrator Utama",
        email: "admin@securapp.com",
        phone: "+628123456789",
        passwordHash: "admin",
        isTwoFactorEnabled: true,
      );
      _authError = null;
      _startTwoFactorAuth();
    } else {
      _authError = "Username atau kata sandi salah!";
      _loginStep = LoginStep.loginSelection;
    }
    notifyListeners();
  }
  
  void autoFillOtp() {
    otpController.text = _twoFactorCode;
    notifyListeners();
  }

  bool verifyOtp(String enteredCode) {
    if (enteredCode == _twoFactorCode) {
      _isLoggedIn = true;
      _loginStep = LoginStep.loggedIn;
      _authError = null;
      _addNotification(
        "Otentikasi dua langkah sukses. Admin ${_currentUser?.fullName ?? ''} masuk.",
      );
      otpController.clear();
      notifyListeners();
      return true;
    } else {
      _authError = "Kode verifikasi (OTP) tidak valid!";
      otpController.clear();
      notifyListeners();
      return false;
    }
  }
  

  void resetLoginFlow() {
    _loginStep = LoginStep.loginSelection;
    _authError = null;
    _twoFactorCode = "";
    otpController.clear();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _loginStep = LoginStep.loginSelection;
    _currentUser = null;
    _twoFactorCode = "";
    otpController.clear();
    notifyListeners();
  }
  
  void updateContactInformation(String email, String phone) {
    // Implement this method
  }

  void updatePassword(String oldPassword, String newPassword) {
    // Implement this method
  }

  void toggle2FA(bool enable) {
    // Implement this method
  }
  
  void updateSystemUserRole(String userId, String newRole) {
    // Implement this method
  }

  void toggleSystemUserStatus(String userId, bool isActive) {
    // Implement this method
  }

  // === SELLER MANAGEMENT ===

  void setSellerSearchQuery(String query) {
    _sellerSearchQuery = query;
    notifyListeners();
  }

  void setSellerFilterStatus(String status) {
    _sellerFilterStatus = status;
    notifyListeners();
  }

  void _startTwoFactorAuth() {
    _twoFactorCode = (100000 + Random().nextInt(900000)).toString();
    _loginStep = LoginStep.twoFactor;
    _addNotification(
      "[OTP SECURE] Kode verifikasi Anda adalah $_twoFactorCode. Berlaku selama 5 menit.",
    );
    notifyListeners();
  }
}
