import 'package:floor/floor.dart';

/// Represents an app access record in the database
@Entity(tableName: 'app_access')
class AppAccess {
  @PrimaryKey()
  final String packageName;
  final String appName;
  final int usageMinutes;
  final bool isBlocked;
  final String category;
  final int limitMinutes;

  AppAccess({
    required this.packageName,
    required this.appName,
    required this.usageMinutes,
    required this.isBlocked,
    required this.category,
    this.limitMinutes = 60,
  });
}

/// Represents a seller in the database
@Entity(tableName: 'sellers')
class Seller {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String email;
  final String storeName;
  final String status; // "Aktif" or "Tidak Aktif"
  final String contact;
  final bool isBanned;
  final String? banReason;

  Seller({
    this.id,
    required this.name,
    required this.email,
    required this.storeName,
    required this.status,
    required this.contact,
    this.isBanned = false,
    this.banReason,
  });
}

/// Represents an approval request in the database
@Entity(tableName: 'approval_requests')
class ApprovalRequest {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String details;
  final String requesterName;
  final int timestamp;
  final String status; // "Menunggu", "Disetujui", "Ditolak"

  ApprovalRequest({
    this.id,
    required this.title,
    required this.details,
    required this.requesterName,
    int? timestamp,
    required this.status,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
}

/// Represents a notification in the database
@Entity(tableName: 'notifications')
class Notification {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String message;
  final int timestamp;
  final bool isRead;

  Notification({
    this.id,
    required this.message,
    int? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
}

/// Represents a user profile in the database
@Entity(tableName: 'user_profiles')
class UserProfile {
  @PrimaryKey()
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String passwordHash;
  final bool isTwoFactorEnabled;

  UserProfile({
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.passwordHash,
    this.isTwoFactorEnabled = false,
  });
}