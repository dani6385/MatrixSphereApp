import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:rxdart/rxdart.dart';
import '../../data/repository/app_repository.dart';
import '../screens/login_screen.dart';
//import '../app_access.dart';
//import '../approval_screens/approval_screen.dart';
//import 'package:securapp/data/models/notification.dart';
//import '../seller_screens/seller_screen.dart';
//import 'package:securapp/data/models/user_profile.dart';
// removed invalid relative import; use ../../app_repository.dart above
//import '../login_screens/login_screen.dart';
//import 'package:shared_ui/shared_ui.dart';


class AppViewModel extends StateNotifier<AppState> {
  final AppRepository repository;

  AppViewModel(this.repository) : super(AppState.initial()) {
    // Initialize database with default data
    _initializeDatabase();
  }

  // Auth States
  void setIsLoggedIn(bool value) => state = state.copyWith(isLoggedIn: value);
  void setCurrentUser(UserProfile? user) => state = state.copyWith(currentUser: user);
  void setLoginStep(LoginStep step) => state = state.copyWith(loginStep: step);
  void setTwoFactorCode(String code) => state = state.copyWith(twoFactorCode: code);

  // UI Message states
  void setAuthError(String? error) => state = state.copyWith(authError: error);
  void setProfileSuccessMessage(String? message) => state = state.copyWith(profileSuccessMessage: message);

  // UI Search and Filter States for Seller Screen
  void setSellerSearchQuery(String query) => state = state.copyWith(sellerSearchQuery: query);
  void setSellerFilterStatus(String status) => state = state.copyWith(sellerFilterStatus: status);

  // Database Flows
  late final Stream<List<AppAccess>> appAccessList = repository.appAccessList;
  late final Stream<List<Seller>> sellers = repository.sellers;
  late final Stream<List<ApprovalRequest>> approvalRequests = repository.approvalRequests;
  late final Stream<List<Notification>> notifications = repository.notifications;

  Future<void> _initializeDatabase() async {
    // Setup default profile
    final existingAdmin = await repository.getUserProfileDirect("admin");
    if (existingAdmin == null) {
      final defaultAdmin = UserProfile(
        username: "admin",
        fullName: "Administrator Utama",
        email: "admin@securapp.com",
        phone: "+628123456789",
        passwordHash: "admin",
        isTwoFactorEnabled: true, // Pre-enable 2FA to showcase the full flow requested
      );
      await repository.insertUserProfile(defaultAdmin);
      setCurrentUser(defaultAdmin);
    } else {
      setCurrentUser(existingAdmin);
    }

    // Setup default monitored apps
    final appList = await repository.appAccessList.first;
    if (appList.isEmpty) {
      final apps = [
        AppAccess(packageName: "com.google.android.youtube", "YouTube", 120, isBlocked: false, "Sosial & Video", 90),
        AppAccess(packageName: "com.zhiliaoapp.musically", "TikTok", 240, isBlocked: true, "Sosial & Video", 60),
        AppAccess(packageName: "com.mobile.legends", "Mobile Legends", 180, isBlocked: false, "Game", 120),
        AppAccess(packageName: "com.whatsapp", "WhatsApp", 95, isBlocked: false, "Komunikasi", 180),
        AppAccess(packageName: "com.instagram.android", "Instagram", 150, isBlocked: false, "Sosial & Video", 90),
        AppAccess(packageName: "com.facebook.katana", "Facebook", 45, isBlocked: false, "Sosial & Video", 120),
        AppAccess(packageName: "com.tencent.ig", "PUBG Mobile", 110, isBlocked: true, "Game", 60),
        AppAccess(packageName: "com.spotify.music", "Spotify", 75, isBlocked: false, "Hiburan & Musik", 240),
        AppAccess(packageName: "com.discord", "Discord", 60, isBlocked: false, "Komunikasi", 120),
      ];
      for (final app in apps) {
        await repository.insertAppAccess(app);
      }
    }

    // Setup default sellers
    final sellerList = await repository.sellers.first;
    if (sellerList.isEmpty) {
      final sellersList = [
        Seller(id: 1, name: "Budi Santoso", email: "budi.santoso@gmail.com", storeName: "Budi Tech", status: "Aktif", contact: "08129876543", isBanned: false),
        Seller(id: 2, name: "Susi Susanti", email: "susi.susanti@gmail.com", storeName: "Susi Fashion", status: "Aktif", contact: "08561234567", isBanned: false),
        Seller(id: 3, name: "Ahmad Fauzi", email: "ahmad.fauzi@yahoo.com", storeName: "Ahmad Gadget", status: "Aktif", contact: "08134567890", isBanned: false),
        Seller(id: 4, name: "Dewi Lestari", email: "dewi.lestari@outlook.com", storeName: "Dewi Books", status: "Tidak Aktif", contact: "08576543210", isBanned: true),
        Seller(id: 5, name: "Rudi Hartono", email: "rudi.hartono@protonmail.com", storeName: "Rudi Clothing", status: "Aktif", contact: "08123456789", isBanned: false),
      ];
      for (final seller in sellersList) {
        await repository.insertSeller(seller);
      }
    }
  }
}

class AppState {
  final bool isLoggedIn;
  final UserProfile? currentUser;
  final LoginStep loginStep;
  final String twoFactorCode;
  final String? authError;
  final String? profileSuccessMessage;
  final String sellerSearchQuery;
  final String sellerFilterStatus;

  AppState({
    required this.isLoggedIn,
    this.currentUser,
    required this.loginStep,
    required this.twoFactorCode,
    this.authError,
    this.profileSuccessMessage,
    required this.sellerSearchQuery,
    required this.sellerFilterStatus,
  });

  factory AppState.initial() => AppState(
    isLoggedIn: false,
    loginStep: LoginStep.loginSelection,
    twoFactorCode: "",
    sellerSearchQuery: "",
    sellerFilterStatus: "Semua",
  );

  AppState copyWith({
    bool? isLoggedIn,
    UserProfile? currentUser,
    LoginStep? loginStep,
    String? twoFactorCode,
    String? authError,
    String? profileSuccessMessage,
    String? sellerSearchQuery,
    String? sellerFilterStatus,
  }) {
    return AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentUser: currentUser ?? this.currentUser,
      loginStep: loginStep ?? this.loginStep,
      twoFactorCode: twoFactorCode ?? this.twoFactorCode,
      authError: authError ?? this.authError,
      profileSuccessMessage: profileSuccessMessage ?? this.profileSuccessMessage,
      sellerSearchQuery: sellerSearchQuery ?? this.sellerSearchQuery,
      sellerFilterStatus: sellerFilterStatus ?? this.sellerFilterStatus,
    );
  }
}