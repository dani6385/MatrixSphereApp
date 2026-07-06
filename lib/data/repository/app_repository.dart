// Ignore analyzer errors about generated files not yet created by build_runner
// This avoids spurious "Target of URI hasn't been generated" errors during analysis.
// ignore_for_file: uri_has_not_been_generated
import 'package:floor/floor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
//import 'package:rxdart/rxdart.dart';

// Generated files may not exist until build_runner is run. Ignore missing URI here.
// ignore: uri_does_not_exist
part '../../presentation/app_repository.freezed.dart'; // For data classes (optional, using freezed)
// ignore: uri_does_not_exist
part '../../presentation/app_repository.g.dart'; // For Floor database generation

// Data Models (equivalent to Kotlin data classes)
@freezed
class AppAccess with _$AppAccess {
  const factory AppAccess({
    required String packageName,
    required bool isBlocked,
    String? lastBlockedTime,
  }) = _AppAccess;
}

@freezed
class Seller with _$Seller {
  const factory Seller({
    required int id,
    required String name,
    required String status,
    required bool isBanned,
    String? banReason,
  }) = _Seller;
}

@freezed
class ApprovalRequest with _$ApprovalRequest {
  const factory ApprovalRequest({
    required int id,
    required String status,
    required String requestDetails,
  }) = _ApprovalRequest;
}

@freezed
class Notification with _$Notification {
  const factory Notification({
    required int id,
    required String message,
    required bool isRead,
    required DateTime timestamp,
  }) = _Notification;
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String username,
    required String displayName,
    String? email,
    String? avatarUrl,
  }) = _UserProfile;
}

// DAO Interface (equivalent to AppDao)
@dao
abstract class AppDao {
  // App Access
  @Query('SELECT * FROM app_access')
  Stream<List<AppAccess>> getAppAccessList();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAppAccess(AppAccess app);

  @Query('UPDATE app_access SET isBlocked = :isBlocked WHERE packageName = :packageName')
  Future<void> updateAppAccessBlockStatus(String packageName, bool isBlocked);

  // Sellers
  @Query('SELECT * FROM sellers')
  Stream<List<Seller>> getSellers();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSeller(Seller seller);

  @Query('UPDATE sellers SET status = :status WHERE id = :id')
  Future<void> updateSellerStatus(int id, String status);

  @Query('UPDATE sellers SET isBanned = :isBanned, banReason = :banReason WHERE id = :id')
  Future<void> updateSellerBanStatus(int id, bool isBanned, String? banReason);

  @Query('DELETE FROM sellers WHERE id = :id')
  Future<void> deleteSeller(int id);

  // Approval Requests
  @Query('SELECT * FROM approval_requests')
  Stream<List<ApprovalRequest>> getApprovalRequests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertApprovalRequest(ApprovalRequest request);

  @Query('UPDATE approval_requests SET status = :status WHERE id = :id')
  Future<void> updateApprovalStatus(int id, String status);

  // Notifications
  @Query('SELECT * FROM notifications')
  Stream<List<Notification>> getNotifications();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotification(Notification notification);

  @Query('UPDATE notifications SET isRead = 1 WHERE id = :id')
  Future<void> markNotificationAsRead(int id);

  @Query('UPDATE notifications SET isRead = 1')
  Future<void> markAllNotificationsAsRead();

  // User Profile
  @Query('SELECT * FROM user_profiles WHERE username = :username LIMIT 1')
  Future<UserProfile?> getUserProfileDirect(String username);

  @Query('SELECT * FROM user_profiles WHERE username = :username LIMIT 1')
  Stream<UserProfile?> getUserProfile(String username);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUserProfile(UserProfile profile);
}

// Repository Implementation
class AppRepository {
  final AppDao _appDao;

  AppRepository(this._appDao);

  // App Access
  Stream<List<AppAccess>> get appAccessList => _appDao.getAppAccessList();

  Future<void> insertAppAccess(AppAccess app) => _appDao.insertAppAccess(app);

  Future<void> updateAppAccessBlockStatus(String packageName, bool isBlocked) =>
      _appDao.updateAppAccessBlockStatus(packageName, isBlocked);

  // Sellers
  Stream<List<Seller>> get sellers => _appDao.getSellers();

  Future<void> insertSeller(Seller seller) => _appDao.insertSeller(seller);

  Future<void> updateSellerStatus(int id, String status) =>
      _appDao.updateSellerStatus(id, status);

  Future<void> updateSellerBanStatus(int id, bool isBanned, String? banReason) =>
      _appDao.updateSellerBanStatus(id, isBanned, banReason);

  Future<void> deleteSeller(int id) => _appDao.deleteSeller(id);

  // Approval Requests
  Stream<List<ApprovalRequest>> get approvalRequests => _appDao.getApprovalRequests();

  Future<void> insertApprovalRequest(ApprovalRequest request) =>
      _appDao.insertApprovalRequest(request);

  Future<void> updateApprovalStatus(int id, String status) =>
      _appDao.updateApprovalStatus(id, status);

  // Notifications
  Stream<List<Notification>> get notifications => _appDao.getNotifications();

  Future<void> insertNotification(Notification notification) =>
      _appDao.insertNotification(notification);

  Future<void> markNotificationAsRead(int id) => _appDao.markNotificationAsRead(id);

  Future<void> markAllNotificationsAsRead() => _appDao.markAllNotificationsAsRead();

  // User Profile
  Future<UserProfile?> getUserProfileDirect(String username) =>
      _appDao.getUserProfileDirect(username);

  Stream<UserProfile?> getUserProfile(String username) => _appDao.getUserProfile(username);

  Future<void> insertUserProfile(UserProfile profile) => _appDao.insertUserProfile(profile);
}