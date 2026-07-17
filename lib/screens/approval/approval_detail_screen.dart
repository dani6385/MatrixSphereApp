import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/approval_model.dart';

class ApprovalDetailScreen extends StatefulWidget {
  // Terima ID unik untuk data yang akan ditampilkan
  final String approvalId;

  const ApprovalDetailScreen({super.key, required this.approvalId});

  @override
  State<ApprovalDetailScreen> createState() => _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends State<ApprovalDetailScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Approval? _approval;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApprovalDetails();
  }

  Future<void> _fetchApprovalDetails() async {
    try {
      final snapshot =
          await _dbRef.child('approval/${widget.approvalId}').get();
      if (snapshot.exists && mounted) {
        setState(() {
          _approval = Approval.fromMap(snapshot.key!, snapshot.value as Map<dynamic, dynamic>);
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
        // Mungkin tampilkan pesan bahwa data tidak ditemukan
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      // Tampilkan error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Persetujuan'),
        backgroundColor: kDarkAppBar,
      ),
      backgroundColor: kDarkBackground,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _approval == null
              ? const Center(
                  child: Text('Data tidak ditemukan.',
                      style: TextStyle(color: kDarkTextPrimary)))
              : _buildContent(),
      bottomNavigationBar:
          _approval != null ? _buildActionButtons(context, _approval!) : null,
    );
  }

  // --- Widget Builders ---
  // Memecah UI menjadi bagian-bagian yang lebih kecil dan mudah dikelola.

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSellerInfoCard(_approval!),
          const SizedBox(height: AppSpacing.lg),
          _buildProofCard(),
          const SizedBox(height: AppSpacing.lg),
          _buildLocationCard(),
          const SizedBox(height: AppSpacing.lg),
          _buildStatusChip(_approval!),
        ],
      ),
    );
  }

  Widget _buildSellerInfoCard(Approval approval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Informasi Calon Seller'),
        const SizedBox(height: AppSpacing.xs),
        Card(
          color: kDarkSurface,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildInfoRow(context, 'Nama Toko', approval.nama),
                const Divider(color: kDarkDivider),
                _buildInfoRow(context, 'Deskripsi',
                    'Segera buka di Seller Sphere'), // Placeholder
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProofCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Bukti Pendukung'),
        const SizedBox(height: AppSpacing.xs),
        Card(
          color: kDarkSurface,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Image.network(
                'https://via.placeholder.com/400x300', // Placeholder
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text('Bukti berupa gambar',
                    style: TextStyle(color: kDarkTextSecondary)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Lokasi'),
        const SizedBox(height: AppSpacing.xs),
        Card(
          color: kDarkSurface,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildInfoRow(
              context,
              'Koordinat',
              'Titik Koordinat (Contoh: -6.200000, 106.816666)', // Placeholder
              isIcon: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(Approval approval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Status'),
        const SizedBox(height: AppSpacing.xs),
        Chip(
          label: Text(
            approval.status.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: approval.status == 'waiting'
              ? Colors.orange.shade800
              : Colors.green.shade800,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        ),
      ],
    );
  }

  // --- Helper Widgets ---
  // Widget-widget kecil yang dapat digunakan kembali di dalam file ini.

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: kDarkTextPrimary),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool isIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isIcon)
            const Icon(Icons.location_on, color: kDarkTextSecondary, size: 20),
          if (isIcon) const SizedBox(width: AppSpacing.xs),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: kDarkTextSecondary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: kDarkTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Approval approval) {
    return BottomAppBar(
      color: kDarkAppBar,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs, horizontal: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text('Tolak'),
                onPressed: () {
                  // TODO: Implement reject logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAlertRed,
                  foregroundColor: kDarkTextPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: kDarkTextPrimary),
                label: const Text('Setujui'),
                onPressed: () {
                  // TODO: Implement approve logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSoftTeal,
                  foregroundColor: kDarkTextPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
