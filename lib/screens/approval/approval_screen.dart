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
      // 1. Dapatkan semua ID pengguna dari shop_sphere
      final shopSphereSnapshot = await _dbRef.child('shop_sphere').get();
      if (!shopSphereSnapshot.exists) {
        throw Exception("Shop sphere is empty!");
      }

      final shoppers = shopSphereSnapshot.value as Map<dynamic, dynamic>;
      final Map<String, Object?> updates = {};

      // 2. Siapkan pembaruan untuk setiap pengguna
      for (var shopperId in shoppers.keys) {
        final recommendationPath = 'system/rekomendasi/$shopperId/${approval.id}';
        updates[recommendationPath] = {
          'bukti': 'berupa gambar', // Placeholder
          'seller': '${approval.nama} segera buka di seller sphere',
          'tikor': 'berupa titik koordinat', // Placeholder
        };
      }

      // 3. Hapus dari daftar persetujuan
      updates['approval/${approval.id}'] = null;

      // 4. Lakukan semua pembaruan dalam satu transaksi atomik
      await _dbRef.update(updates);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Toko ${approval.nama} disetujui dan direkomendasikan."),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal menyetujui toko: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _rejectShop(Approval approval) async {
    try {
      await _dbRef.child('approval/${approval.id}').remove();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Pendaftaran toko ${approval.nama} ditolak."),
        backgroundColor: Colors.orange,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal menolak toko: $e"),
        backgroundColor: Colors.red,
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
