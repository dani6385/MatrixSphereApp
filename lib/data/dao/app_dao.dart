import 'package:drift/drift.dart';
import '../model/app_access.dart';
import '../db/app_database.dart';

part '../../presentation/app_dao.g.dart'; // TODO: Run 'flutter pub run build_runner build' to generate this file

@DataClassName('AppAccess')
class AppAccesses extends Table {
  TextColumn get packageName => text()();
  IntColumn get usageMinutes => integer()();
  BoolColumn get isBlocked => boolean().withDefault(const Constant(false))();
}

@DataClassName('Seller')
class Sellers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get status => text()();
  BoolColumn get isBanned => boolean().withDefault(const Constant(false))();
  TextColumn get banReason => text().nullable()();
}

@DataClassName('ApprovalRequest')
class ApprovalRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get requester => text()();
  TextColumn get status => text()();
  DateTimeColumn get timestamp => dateTime()();
}

@DataClassName('Notification')
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get timestamp => dateTime()();
}

@DataClassName('UserProfile')
class UserProfiles extends Table {
  TextColumn get username => text()();
  TextColumn get displayName => text()();
  TextColumn get email => text()();
  TextColumn get bio => text().nullable()();
}

@DriftAccessor(tables: [
  AppAccesses,
  Sellers,
  ApprovalRequests,
  Notifications,
  UserProfiles,
])
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(AppDatabase db) : super(db);

  // App Access Queries
  Stream<List<AppAccess>> getAppAccessList() {
    return (select(appAccesses)..orderBy([(t) => OrderingTerm(expression: t.usageMinutes, mode: OrderingMode.desc)])).watch();
  }

  Future<int> insertAppAccess(AppAccess app) {
    return into(appAccesses).insert(app);
  }

  Future<bool> updateAppAccessBlockStatus(String packageName, bool isBlocked) {
    return (update(appAccesses)..where((t) => t.packageName.equals(packageName))).write(AppAccessesCompanion(isBlocked: Value(isBlocked)));
  }

  // Seller Queries
  Stream<List<Seller>> getSellers() {
    return (select(sellers)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])).watch();
  }

  Future<int> insertSeller(Seller seller) {
    return into(sellers).insert(seller);
  }

  Future<bool> updateSellerStatus(int id, String status) {
    return (update(sellers)..where((t) => t.id.equals(id))).write(SellersCompanion(status: Value(status)));
  }

  Future<bool> updateSellerBanStatus(int id, bool isBanned, String? banReason) {
    return (update(sellers)..where((t) => t.id.equals(id))).write(SellersCompanion(isBanned: Value(isBanned), banReason: Value(banReason)));
  }

  Future<int> deleteSeller(int id) {
    return (delete(sellers)..where((t) => t.id.equals(id))).go();
  }

  // Approval Request Queries
  Stream<List<ApprovalRequest>> getApprovalRequests() {
    return (select(approvalRequests)..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])).watch();
  }

  Future<int> insertApprovalRequest(ApprovalRequest request) {
    return into(approvalRequests).insert(request);
  }

  Future<bool> updateApprovalStatus(int id, String status) {
    return (update(approvalRequests)..where((t) => t.id.equals(id))).write(ApprovalRequestsCompanion(status: Value(status)));
  }

  // Notification Queries
  Stream<List<Notification>> getNotifications() {
    return (select(notifications)..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])).watch();
  }

  Future<int> insertNotification(Notification notification) {
    return into(notifications).insert(notification);
  }

  Future<bool> markNotificationAsRead(int id) {
    return (update(notifications)..where((t) => t.id.equals(id))).write(NotificationsCompanion(isRead: const Value(true)));
  }

  Future<bool> markAllNotificationsAsRead() {
    return update(notifications).write(const NotificationsCompanion(isRead: Value(true)));
  }

  // User Profile Queries
  Future<UserProfile?> getUserProfileDirect(String username) {
    return (select(userProfiles)..where((t) => t.username.equals(username))).getSingleOrNull();
  }

  Stream<UserProfile?> getUserProfile(String username) {
    return (select(userProfiles)..where((t) => t.username.equals(username))).watchSingleOrNull();
  }

  Future<int> insertUserProfile(UserProfile profile) {
    return into(userProfiles).insert(profile);
  }
}

@DriftDatabase(tables: [
  AppAccesses,
  Sellers,
  ApprovalRequests,
  Notifications,
  UserProfiles,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy();

  AppDao get appDao => AppDao(this);
}