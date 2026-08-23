import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool isLoadingLocation;
  final bool isInRange;
  final double distanceToOffice;
  final bool isProcessing;
  final VoidCallback? onSubmit;

  const ControlPanel({
    Key? key,
    required this.isLoadingLocation,
    required this.isInRange,
    required this.distanceToOffice,
    required this.isProcessing,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLocationStatus(),
            const SizedBox(height: 16.0),
            const Text(
              "Posisikan wajah Anda di dalam lingkaran",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13.0),
            ),
            const SizedBox(height: 16.0),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStatus() {
    if (isLoadingLocation) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          SizedBox(width: 10),
          Text("Memverifikasi lokasi GPS...", style: TextStyle(color: Colors.white)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isInRange ? Icons.location_on : Icons.location_off,
          color: isInRange ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            isInRange
                ? "Lokasi Sesuai (Jarak: ${distanceToOffice.toStringAsFixed(1)}m)"
                : "Terlalu Jauh dari Kantor (Jarak: ${distanceToOffice.toStringAsFixed(1)}m)",
            style: TextStyle(
              color: isInRange ? Colors.green : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (isProcessing) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          "Ambil Foto & Absen",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }
}