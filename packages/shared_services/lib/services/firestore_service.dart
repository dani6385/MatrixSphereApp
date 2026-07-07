import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- App Access ---
  Stream<QuerySnapshot> getAppAccessList() {
    return _firestore.collection('app_access').snapshots();
  }

  Future<void> updateAppAccessBlockStatus(String packageName, bool isBlocked) {
    return _firestore.collection('app_access').doc(packageName).update({'isBlocked': isBlocked});
  }

  // --- Sellers ---
  Stream<QuerySnapshot> getSellers() {
    // Mengurutkan berdasarkan nama untuk konsistensi
    return _firestore.collection('sellers').orderBy('name').snapshots();
  }

  Future<void> updateSellerBanStatus(String id, bool isBanned, String? banReason) {
    return _firestore.collection('sellers').doc(id).update({
      'isBanned': isBanned,
      'banReason': banReason, // Firestore akan menghapus field jika nilainya null
      'status': isBanned ? 'Tidak Aktif' : 'Aktif',
    });
  }

  // --- Approval Requests ---
  Stream<QuerySnapshot> getApprovalRequests() {
    // Mengurutkan berdasarkan timestamp, yang terbaru di atas
    return _firestore.collection('approval_requests').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateApprovalStatus(String id, String status) {
    return _firestore.collection('approval_requests').doc(id).update({'status': status});
  }

  // --- Notifications ---
  Stream<QuerySnapshot> getNotifications() {
    // Mengurutkan berdasarkan timestamp, yang terbaru di atas
    return _firestore.collection('notifications').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> insertNotification(Map<String, dynamic> notificationData) {
     // Menambahkan timestamp server saat data ditulis
    notificationData['timestamp'] = FieldValue.serverTimestamp();
    notificationData['isRead'] = false;
    return _firestore.collection('notifications').add(notificationData);
  }

  Future<void> markNotificationAsRead(String id) {
    return _firestore.collection('notifications').doc(id).update({'isRead': true});
  }

  Future<void> markAllNotificationsAsRead() async {
    final WriteBatch batch = _firestore.batch();
    final querySnapshot = await _firestore.collection('notifications').where('isRead', isEqualTo: false).get();

    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    return batch.commit();
  }

  // --- User Profile ---
  Stream<DocumentSnapshot> getUserProfile(String username) {
    return _firestore.collection('user_profiles').doc(username).snapshots();
  }

  Future<void> updateUserProfile(String username, Map<String, dynamic> data) {
      return _firestore.collection('user_profiles').doc(username).update(data);
  }
}
