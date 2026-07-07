import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalRequest {
  final String id;
  final String title;
  final String requesterName;
  final String details;
  final DateTime timestamp;
  final String status; // "Menunggu", "Disetujui", "Ditolak"

  ApprovalRequest({
    required this.id,
    required this.title,
    required this.requesterName,
    required this.details,
    required this.timestamp,
    this.status = "Menunggu",
  });

  factory ApprovalRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ApprovalRequest(
      id: doc.id,
      title: data['title'] ?? '',
      requesterName: data['requesterName'] ?? '',
      details: data['details'] ?? '',
      // Convert Firestore Timestamp to Dart DateTime
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'Menunggu',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'requesterName': requesterName,
      'details': details,
      'timestamp': Timestamp.fromDate(timestamp), // Convert DateTime to Firestore Timestamp
      'status': status,
    };
  }

  ApprovalRequest copyWith({
    String? id,
    String? title,
    String? requesterName,
    String? details,
    DateTime? timestamp,
    String? status,
  }) {
    return ApprovalRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      requesterName: requesterName ?? this.requesterName,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
