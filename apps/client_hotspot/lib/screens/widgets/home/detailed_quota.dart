import 'package:flutter/material.dart';

class DetailedQuota extends StatelessWidget {
  const DetailedQuota({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data (nantinya bisa diganti dengan data dari state atau API)
    const double totalQuota = 32.0; // GB
    const double usedQuota = 7.3; // GB
    final double availableQuota = totalQuota - usedQuota;
    final double percentageUsed = usedQuota / totalQuota;

    final Color primaryColor = const Color(0xFF0D1E40); // Deep Sapphire
    final Color accentColor = const Color(0xFF2196F3); // Modern Blue

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Usage Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Data Usage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildCircularProgress(
                  availableQuota,
                  totalQuota,
                  percentageUsed,
                  accentColor,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sisa Masa Aktif',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  '21 Hari',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildLinearProgress(percentageUsed, accentColor),
                const SizedBox(height: 8),
                _buildUsageRow(usedQuota, availableQuota),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress(
    double available,
    double total,
    double percentage,
    Color accentColor,
  ) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: percentage,
            strokeWidth: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${available.toStringAsFixed(1)} GB',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '/ ${total.toStringAsFixed(1)} GB',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinearProgress(double percentage, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 15,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildUsageRow(double used, double available) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digunakan (Used)',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${used.toStringAsFixed(1)} GB',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Tersedia (Available)',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${available.toStringAsFixed(1)} GB',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}
