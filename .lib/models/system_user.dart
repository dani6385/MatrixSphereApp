import 'package:cloud_firestore/cloud_firestore.dart';

class SystemUser {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String status;

  SystemUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
  });

  factory SystemUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SystemUser(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Viewer',
      status: data['status'] ?? 'Tidak Aktif',
    );
  }
}
