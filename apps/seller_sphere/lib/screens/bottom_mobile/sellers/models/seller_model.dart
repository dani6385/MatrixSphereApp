import 'package:flutter/material.dart';

class Seller {
  final IconData icon;
  final Color iconColor;
  final String storeName;
  final String ownerName;
  final String email;
  final String phone;
  final String status;
  final Color statusColor;

  Seller({
    required this.icon,
    required this.iconColor,
    required this.storeName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.status,
    required this.statusColor,
  });
}
