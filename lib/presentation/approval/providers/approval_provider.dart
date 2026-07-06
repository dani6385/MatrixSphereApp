
import 'package:flutter/foundation.dart';

enum ApprovalStatus { pending, approved, rejected }

class ApprovalItem {
  final String id;
  final String title;
  final String subtitle;
  final ApprovalStatus status;

  ApprovalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.status = ApprovalStatus.pending,
  });
}

class ApprovalProvider with ChangeNotifier {
  final List<ApprovalItem> _items = [
    ApprovalItem(id: '1', title: 'Pendaftaran Mitra Baru', subtitle: 'Toko Kelontong Sejahtera'),
    ApprovalItem(id: '2', title: 'Permintaan Penambahan Stok', subtitle: 'Warung Ibu Siti'),
    ApprovalItem(id: '3', title: 'Verifikasi Lokasi Usaha', subtitle: 'Kios Barokah Jaya', status: ApprovalStatus.approved),
    ApprovalItem(id: '4', title: 'Pengajuan Cuti Karyawan', subtitle: 'Budi Santoso'),
    ApprovalItem(id: '5', title: 'Klaim Garansi Produk', subtitle: 'Pelanggan: Bapak Agus', status: ApprovalStatus.rejected),
  ];

  List<ApprovalItem> get items => _items;

  List<ApprovalItem> get pendingItems => _items.where((item) => item.status == ApprovalStatus.pending).toList();

  void approve(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = ApprovalItem(
        id: _items[index].id,
        title: _items[index].title,
        subtitle: _items[index].subtitle,
        status: ApprovalStatus.approved,
      );
      notifyListeners();
    }
  }

  void reject(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = ApprovalItem(
        id: _items[index].id,
        title: _items[index].title,
        subtitle: _items[index].subtitle,
        status: ApprovalStatus.rejected,
      );
      notifyListeners();
    }
  }
}
