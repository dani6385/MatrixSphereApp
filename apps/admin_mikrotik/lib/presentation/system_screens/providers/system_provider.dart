import 'package:flutter/material.dart';
import '../models/access_role_model.dart';
import '../models/banned_seller_model.dart';

class SystemProvider extends ChangeNotifier {
  final List<AccessRole> _accessRoles = [
    AccessRole(
      title: 'Administrator Utama',
      username: '@admin',
      role: 'Super Admin',
      isActive: true,
    ),
    AccessRole(
      title: 'SecurApp Moderator',
      username: '@sec_moderator',
      role: 'Moderator',
      isActive: true,
    ),
    AccessRole(
      title: 'Support & IT Helpdesk',
      username: '@support_it',
      role: 'Operator',
      isActive: true,
    ),
    AccessRole(
      title: 'Tamu Sementara',
      username: '@guest_temp',
      role: 'Viewer',
      isActive: false,
    ),
  ];

  final List<BannedSeller> _bannedSellers = [
    BannedSeller(
      storeName: 'Solo Mebel',
      sellerName: 'Joko Widodo',
      reason: 'Penggunaan Bot Akses Tanpa Izin',
    ),
    BannedSeller(
      storeName: 'Lestari Craft',
      sellerName: 'Rini Lestari',
      reason: 'Pelanggaran Ketentuan Transaksi (Spamming)',
    ),
  ];

  List<AccessRole> get accessRoles => _accessRoles;
  List<BannedSeller> get bannedSellers => _bannedSellers;
}
