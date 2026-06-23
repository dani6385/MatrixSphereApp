import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../notifiers/status_notifier.dart';
import '../models/hotspot_status_model.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchHotspotStatus setelah frame pertama selesai dibangun
    // untuk memastikan Notifier tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StatusNotifier>(context, listen: false).fetchHotspotStatus();
    });
  }

  String _formatBytes(double bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  String _formatDuration(Duration d) {
    // Menambahkan mikrodetik untuk memastikan pembulatan ke atas yang benar
    d += const Duration(microseconds: 999999);
    return d.toString().split('.').first.padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Status Sesi Hotspot', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Consumer<StatusNotifier>(
        builder: (context, notifier, child) {
          // --- KONDISI LOADING ---
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- KONDISI ERROR ---
          if (notifier.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal Memuat Status',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notifier.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      onPressed: () => notifier.fetchHotspotStatus(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          // --- KONDISI SUKSES ---
          final status = notifier.hotspotStatus;

          return RefreshIndicator(
            onRefresh: () => notifier.fetchHotspotStatus(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // Selalu bisa di-scroll untuk refresh
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildUserInfoCard(status),
                const SizedBox(height: 20),
                _buildSessionCard(status),
                const SizedBox(height: 20),
                _buildConnectionCard(status),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(HotspotStatus status) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_pin, color: Colors.blueAccent, size: 28),
              const SizedBox(width: 12),
              Text('Informasi Pengguna', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const Divider(height: 24),
          _buildDetailRow('Username', status.username),
          _buildDetailRow('Paket/Profil', status.profile ?? 'Tidak diketahui', showDivider: false),
        ],
      ),
    );
  }

  Widget _buildSessionCard(HotspotStatus status) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Text('Detail Sesi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const Divider(height: 24),
          _buildDetailRow('Durasi Aktif (Uptime)', _formatDuration(status.uptime)),
          _buildDetailRow('Data Upload', _formatBytes(status.bytesUp, 2)),
          _buildDetailRow('Data Download', _formatBytes(status.bytesDown, 2), showDivider: false),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(HotspotStatus status) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lan, color: Colors.purple, size: 28),
              const SizedBox(width: 12),
              Text('Informasi Koneksi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const Divider(height: 24),
          _buildDetailRow('Alamat IP', status.ipAddress),
          _buildDetailRow('Alamat MAC', status.macAddress, showDivider: false),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool showDivider = true}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 15)),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        if (showDivider) const Divider(height: 24),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final Widget child;
  const InfoCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}
