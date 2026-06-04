// packages/service_shared/lib/src/utils/firebase_constants.dart

class FirestoreCollections {
  static const String users = 'users';
  static const String products = 'products';
  static const String orders = 'orders';
}

class FirestoreFields {
  // Contoh field di dalam collection 'users'
  static const String userName = 'display_name';
  static const String userEmail = 'email';
  static const String createdAt = 'created_at';
}

// packages/service_shared/lib/src/utils/firebase_constants.dart

// Path untuk Realtime Database (Gunakan nama yang merepresentasikan lokasi node)
class DatabasePaths {
  static const String mikrotikData = 'mikrotik_data';
  static const String systemStatus = 'system_status';
}

// Field/Key yang ada di dalam node tersebut
class MikrotikFields {
  static const String ipAddress = 'ip_address';
  static const String status = 'status';
  static const String uptime = 'uptime';
  static const String lastSeen = 'last_updated';
}

// Field/Key untuk user (Jika masih digunakan)
class UserFields {
  static const String userName = 'display_name';
  static const String userEmail = 'email';
}