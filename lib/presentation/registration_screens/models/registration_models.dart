// 1. Definisikan Model dan Enum di sini agar bisa diakses secara global
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
  final String email;
  final DateTime registrationDate;
  final RegistrationStatus status;
  final String? rejectionReason;

  const SellerRegistration({
    required this.id,
    required this.partnerName,
    required this.email,
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
      email: email,
      registrationDate: registrationDate,
      status: status ?? this.status,
      rejectionReason: rejectionReason,
    );
  }
}