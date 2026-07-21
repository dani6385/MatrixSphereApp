import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../models/approval_model.dart';
import 'widgets/approval_card.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Approval> _approvals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApprovals();
  }

  void _fetchApprovals() {
    _dbRef.child('approval').onValue.listen((event) {
      if (!mounted) return;

      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final List<Approval> approvals = [];
        data.forEach((key, value) {
          approvals.add(Approval.fromMap(key, value));
        });
        setState(() {
          _approvals = approvals;
          _isLoading = false;
        });
      } else {
        setState(() {
          _approvals = [];
          _isLoading = false;
        });
      }
    }, onError: (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching data: $error"),
      ));
    });
  }

  Future<void> _approveShop(Approval approval) async {
    try {
      // Buat map untuk menampung semua pembaruan database
      final Map<String, Object?> updates = {};

      // 1. Tambahkan toko baru ke 'seller_sphere' dengan data awal.
      //    ID toko akan sama dengan ID yang ada di 'approval'.
      updates['seller_sphere/${approval.id}'] = {
        'nama': approval.nama,
        'status': 'active',
        'createdAt': ServerValue.timestamp, // Menandai kapan toko dibuat
      };

      // 2. Hapus toko dari daftar 'approval'
      updates['approval/${approval.id}'] = null;

      // 3. Lakukan semua pembaruan dalam satu operasi atomik
      await _dbRef.update(updates);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Toko ${approval.nama} telah disetujui dan diaktifkan."),
        backgroundColor: kSoftTeal,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal menyetujui toko: $e"),
        backgroundColor: kAlertRed,
      ));
    }
  }

  Future<void> _rejectShop(Approval approval) async {
    try {
      await _dbRef.child('approval/${approval.id}').remove();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Pendaftaran toko ${approval.nama} ditolak."),
        backgroundColor: kWarmOrange,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal menolak toko: $e"),
        backgroundColor: kAlertRed,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _approvals.isEmpty
                  ? const Center(
                      child: Text(
                      'Tidak ada data persetujuan yang ditemukan.',
                      style: TextStyle(color: kDarkTextPrimary),
                    ))
                  : ListView.builder(
                      itemCount: _approvals.length,
                      itemBuilder: (context, index) {
                        final approval = _approvals[index];
                        return ApprovalCard(
                          title: 'Persetujuan Pendaftaran Toko',
                          subtitle: 'Toko: ${approval.nama}',
                          description:
                              'Pengguna telah mengajukan pendaftaran toko baru dengan nama \'${approval.nama}\'. Mohon tinjau dan berikan persetujuan.',
                          icon: Icons.storefront,
                          iconColor: Colors.blue,
                          onApprove: () => _approveShop(approval),
                          onReject: () => _rejectShop(approval),
                        );
                      },
                    )),
    );
  }
}
