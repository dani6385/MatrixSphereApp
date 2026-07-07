import 'package:flutter/material.dart';
import '../models/approval_model.dart';

class ApprovalProvider extends ChangeNotifier {
  final List<Approval> _waitingApprovals = [
    Approval(
      icon: Icons.person_add_outlined,
      title: 'Pendaftaran Seller Baru',
      requester: 'Pemohon: Rudi Hermawan',
      date: '18.04 06 Jul',
      description: 'Pendaftaran toko `Harapan Jaya` oleh seller Rudi Hermawan. Verifikasi dokumen lengkap.',
    ),
    Approval(
      icon: Icons.lock_open_outlined,
      title: 'Permintaan Buka Blokir',
      requester: 'Pemohon: Rini Lestari',
      date: '18.04 06 Jul',
      description: 'Seller Rini Lestari meminta pemulihan akun setelah menyelesaikan klarifikasi banding.',
    ),
    Approval(
      icon: Icons.cloud_outlined,
      title: 'Akses API Eksternal',
      requester: 'Pemohon: Susi Susanti',
      date: '18.04 06 Jul',
      description: 'Permintaan integrasi webhook transaksi dari Seller `Susi Fashion` untuk platform ERP.',
    ),
  ];

  final List<Approval> _historyApprovals = [];

  List<Approval> get waitingApprovals => _waitingApprovals;
  List<Approval> get historyApprovals => _historyApprovals;

  void approve(Approval approval) {
    _waitingApprovals.remove(approval);
    _historyApprovals.add(approval);
    notifyListeners();
  }

  void reject(Approval approval) {
    _waitingApprovals.remove(approval);
    _historyApprovals.add(approval);
    notifyListeners();
  }
}
