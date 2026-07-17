import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ApprovalDetailScreen extends StatelessWidget {
  const ApprovalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy berdasarkan struktur JSON Anda
    const sellerName = 'Toko Andika';
    const sellerDescription = 'Segera buka di Seller Sphere';
    const proofUrl = 'https://via.placeholder.com/400x300'; // Placeholder untuk gambar bukti
    const coordinates = 'Titik Koordinat (Contoh: -6.200000, 106.816666)';
    const status = 'waiting';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Persetujuan'),
        backgroundColor: kDarkAppBar,
      ),
      backgroundColor: kDarkBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionHeader(context, 'Informasi Calon Seller'),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              color: kDarkSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(context, 'Nama Toko', sellerName),
                    const Divider(color: kDarkDivider),
                    _buildInfoRow(context, 'Deskripsi', sellerDescription),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Bukti Pendukung'),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              color: kDarkSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    proofUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Bukti berupa gambar',
                      style: TextStyle(color: kDarkTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Lokasi'),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              color: kDarkSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildInfoRow(context, 'Koordinat', coordinates, isIcon: true),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Status'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: status == 'waiting' ? Colors.orange.shade800 : Colors.green.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: kDarkTextPrimary),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool isIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isIcon) const Icon(Icons.location_on, color: kDarkTextSecondary, size: 20),
          if (isIcon) const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BottomAppBar(
      color: kDarkAppBar,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text('Tolak'),
                onPressed: () {
                  // TODO: Implement reject logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Setujui'),
                onPressed: () {
                  // TODO: Implement approve logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
