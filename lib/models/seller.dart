import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String id;
  final String name;
  final String storeName;
  final String email;
  final String contact;
  final String status; // "Aktif", "Tidak Aktif"
  final bool isBanned;
  final String? banReason;

  Seller({
    required this.id,
    required this.name,
    required this.storeName,
    required this.email,
    required this.contact,
    this.status = "Aktif",
    this.isBanned = false,
    this.banReason,
  });

  factory Seller.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Seller(
      id: doc.id,
      name: data['name'] ?? '',
      storeName: data['storeName'] ?? '',
      email: data['email'] ?? '',
      contact: data['contact'] ?? '',
      status: data['status'] ?? 'Tidak Aktif',
      isBanned: data['isBanned'] ?? false,
      banReason: data['banReason']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'storeName': storeName,
      'email': email,
      'contact': contact,
      'status': status,
      'isBanned': isBanned,
      'banReason': banReason,
    };
  }

  Seller copyWith({
    String? id,
    String? name,
    String? storeName,
    String? email,
    String? contact,
    String? status,
    bool? isBanned,
    String? banReason,
    bool clearBanReason = false,
  }) {
    return Seller(
      id: id ?? this.id,
      name: name ?? this.name,
      storeName: storeName ?? this.storeName,
      email: email ?? this.email,
      contact: contact ?? this.contact,
      status: status ?? this.status,
      isBanned: isBanned ?? this.isBanned,
      banReason: clearBanReason ? null : banReason ?? this.banReason,
    );
  }
}
