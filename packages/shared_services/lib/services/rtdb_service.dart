import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as developer;

class RtdbService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// Retrieves a stream of data from the specified path.
  Stream<DatabaseEvent> getDataStream(String path) {
    try {
      final ref = _db.ref(path);
      developer.log('Streaming data from $path', name: 'RtdbService');
      return ref.onValue;
    } catch (e, stackTrace) {
      developer.log('Error getting data stream from $path', name: 'RtdbService', error: e, stackTrace: stackTrace, level: 1000);
      rethrow;
    }
  }

  /// Adds data to a list at the specified path, generating a unique ID.
  Future<void> addData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _db.ref(path).push();
      await ref.set(data);
      developer.log('Data added to $path with key ${ref.key}', name: 'RtdbService');
    } catch (e, stackTrace) {
      developer.log('Error adding data to $path', name: 'RtdbService', error: e, stackTrace: stackTrace, level: 1000);
      rethrow;
    }
  }

  /// Updates data at the specified path.
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    try {
      final ref = _db.ref(path);
      await ref.update(data);
      developer.log('Data updated at $path', name: 'RtdbService');
    } catch (e, stackTrace) {
      developer.log('Error updating data at $path', name: 'RtdbService', error: e, stackTrace: stackTrace, level: 1000);
      rethrow;
    }
  }

  /// Deletes data at the specified path.
  Future<void> deleteData(String path) async {
    try {
      final ref = _db.ref(path);
      await ref.remove();
      developer.log('Data deleted from $path', name: 'RtdbService');
    } catch (e, stackTrace) {
      developer.log('Error deleting data from $path', name: 'RtdbService', error: e, stackTrace: stackTrace, level: 1000);
      rethrow;
    }
  }


  /// Mengambil data sesi pengguna dari Firebase Realtime Database.
  ///
  /// [mikrotikId] adalah ID dari node mikrotik (misal: "mikrotik_A_id").
  /// [userId] adalah ID pengguna (misal: "user_123").
  /// Mengembalikan Map yang berisi data pengguna jika ditemukan.
  Future<Map<String, dynamic>?> getUserSession(String mikrotikId, String userId) async {
    try {
      final ref = _db.ref('mikrotiks/$mikrotikId/users/$userId');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        developer.log('User session data retrieved for $userId at $mikrotikId', name: 'RtdbService');
        // Konversi data dari Object? ke Map<String, dynamic>
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data;
      } else {
        developer.log('User session not found for $userId at $mikrotikId', name: 'RtdbService', level: 800);
        return null;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error getting user session from RTDB',
        name: 'RtdbService',
        error: e,
        stackTrace: stackTrace,
        level: 1000, // SEVERE
      );
      rethrow;
    }
  }

  Stream<DatabaseEvent> getApprovalsStream() {
    final ref = _db.ref('approvals');
    return ref.onValue;
  }

  Future<void> updateApprovalStatus(String id, String status) {
    final ref = _db.ref('approvals/$id');
    return ref.update({'status': status});
  }

  Stream<DatabaseEvent> getAchievementsStream() {
    final ref = _db.ref('achievements');
    return ref.onValue;
  }
}