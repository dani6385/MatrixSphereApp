import 'package:flutter/material.dart';
import '../models/seller_model.dart';

class SellerProvider extends ChangeNotifier {
  final List<Seller> _sellers = [
    Seller(
      initial: 'J',
      name: 'Joko Widodo',
      store: 'Solo Mebel',
      email: 'joko.w@gmail.com',
      phone: '08112233445',
      status: 'BANNED',
      reason: 'Alasan: Penggunaan Bot Akses Tanpa Izin',
      isBanned: true,
    ),
    Seller(
      initial: 'D',
      name: 'Dewi Pratama',
      store: 'Dewi Books',
      email: 'dewi.pratama@outlook.com',
      phone: '08772222111',
      status: 'TIDAK AKTIF',
    ),
    Seller(
      initial: 'R',
      name: 'Rini Lestari',
      store: 'Lestari Craft',
      email: 'rini.lestari@gmail.com',
      phone: '08215555444',
      status: 'BANNED',
      reason: 'Alasan: Pelanggaran Ketentuan Transaksi (Spamming)',
      isBanned: true,
    ),
    Seller(
      initial: 'A',
      name: 'Ahmad Fauzi',
      store: 'Fauzi Jaya',
      email: 'ahmad.fauzi@yahoo.com',
      phone: '08567890123',
      status: 'AKTIF',
    ),
  ];

  List<Seller> get sellers => _sellers;
}
