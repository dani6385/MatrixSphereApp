import 'package:cloud_firestore/cloud_firestore.dart';

enum SortType {
  dateNewest,
  dateOldest,
  nameAsc,
  nameDesc,
}

enum RegistrationStatus { pending, approved, rejected }

class SellerRegistration {
  final String id;
  final String partnerName;
  final String? ownerName;
  final String? phone;
  final String? address;
  final String? email; 
  final DateTime registrationDate;
  final RegistrationStatus status;
  final String? rejectionReason;

  const SellerRegistration({
    required this.id,
    required this.partnerName,
    this.ownerName,
    this.phone,
    this.address,
    this.email,
    required this.registrationDate,
    required this.status,
    this.rejectionReason,
  });

  SellerRegistration copyWith({
    RegistrationStatus? status,
    String? rejectionReason,
  }) {
    return SellerRegistration(
      id: id,
      partnerName: partnerName,
      ownerName: ownerName,
      phone: phone,
      address: address,
      email: email,
      registrationDate: registrationDate,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  factory SellerRegistration.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final statusString = data['status'] as String? ?? 'pending';

    RegistrationStatus status;
    switch (statusString) {
      case 'approved': status = RegistrationStatus.approved; break;
      case 'rejected': status = RegistrationStatus.rejected; break;
      default: status = RegistrationStatus.pending; break;
    }

    return SellerRegistration(
      id: doc.id,
      partnerName: data['partnerName'] ?? 'Nama Tidak Ada',
      ownerName: data['ownerName'],
      phone: data['phone'],
      address: data['address'],
      email: data['email'],
      registrationDate: (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: status,
      rejectionReason: data['rejectionReason'],
    );
  }
}
