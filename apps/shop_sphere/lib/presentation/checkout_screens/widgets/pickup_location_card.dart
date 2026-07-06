import 'package:flutter/material.dart';

/// Widget Card untuk menampilkan detail lokasi penjemputan dan status
/// verifikasi jarak pengguna dari toko.
class PickupLocationCard extends StatelessWidget {
  final bool isCheckingLocation;
  final double? distanceInMeters;
  final String distanceStatusMessage;

  const PickupLocationCard({
    super.key,
    required this.isCheckingLocation,
    required this.distanceInMeters,
    required this.distanceStatusMessage,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isCheckingLocation ? Colors.blue : (distanceInMeters == null || distanceInMeters! > 3000) ? Colors.red : Colors.green;
    final statusIcon = isCheckingLocation ? Icons.location_searching : (distanceInMeters == null || distanceInMeters! > 3000) ? Icons.error_outline : Icons.check_circle_outline;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Toko MatrixSphere', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Jl. Digital No. 20, Gedung MatrixSphere Lt. 5, Kota Bandung, Jawa Barat 40222'),
            const Divider(height: 20),
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(distanceStatusMessage, style: const TextStyle(fontSize: 12))),
              ],
            )
          ],
        ),
      ),
    );
  }
}