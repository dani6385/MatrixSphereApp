// lib/feature/employees/models/employee_model.dart
import 'package:flutter/foundation.dart';

@immutable
class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // Contoh: 'Kasir', 'Staf Gudang'

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  // Method untuk membuat salinan objek dengan data yang diubah
  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}
