import 'package:cloud_firestore/cloud_firestore.dart';

class AppAccess {
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

  factory AppAccess.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppAccess(
      packageName: doc.id,
      appName: data['appName'] ?? '',
      usageMinutes: data['usageMinutes'] ?? 0,
      isBlocked: data['isBlocked'] ?? false,
      category: data['category'] ?? 'Unknown',
      limitMinutes: data['limitMinutes'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'usageMinutes': usageMinutes,
      'isBlocked': isBlocked,
      'category': category,
      'limitMinutes': limitMinutes,
    };
  }

  AppAccess copyWith({
    String? packageName,
    String? appName,
    int? usageMinutes,
    bool? isBlocked,
    String? category,
    int? limitMinutes,
  }) {
    return AppAccess(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      usageMinutes: usageMinutes ?? this.usageMinutes,
      isBlocked: isBlocked ?? this.isBlocked,
      category: category ?? this.category,
      limitMinutes: limitMinutes ?? this.limitMinutes,
    );
  }
}
