import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/shopsphere_order.dart';

class ManualVerificationView extends StatelessWidget {
  final ShopsphereOrder order;
  final String inputCode;
  final bool isScanning;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onSimulateScan;

  const ManualVerificationView({
    super.key,
    required this.order,
    required this.inputCode,
    required this.isScanning,
    required this.onCodeChanged,
    required this.onSimulateScan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Gunakan barcode pembeli atau ketik kode verifikasi 6-digit.", style: TextStyle(fontSize: 11, color: Colors.white70)),
        const SizedBox(height: 8),
        _SimulatedBarcode(code: order.verificationCode, isScanning: isScanning),
        const SizedBox(height: 8),
        if(isScanning)
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: kNeonCyan)),
              SizedBox(width: 8),
              Text("Memindai Barcode...", style: TextStyle(fontSize: 12, color: kNeonCyan, fontWeight: FontWeight.bold)),
            ],
          )
        else
          TextField(
            controller: TextEditingController(text: inputCode)..selection = TextSelection.fromPosition(TextPosition(offset: inputCode.length)),
            onChanged: onCodeChanged,
            maxLength: 6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 3),
            decoration: InputDecoration(
              labelText: "Kode Verifikasi (6 Digit)",
              counterText: "",
              hintText: order.verificationCode,
              hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kNeonCyan))
            ),
          ),
         const SizedBox(height: 8),
         ElevatedButton.icon(
           onPressed: onSimulateScan,
           icon: const Icon(Icons.qr_code, size: 16),
           label: const Text("Simulasi Scan Barcode 📸", style: TextStyle(fontSize: 12)),
           style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
           ),
         )
      ],
    );
  }
}

class _SimulatedBarcode extends StatelessWidget {
  final String code;
  final bool isScanning;
  const _SimulatedBarcode({required this.code, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Simplified barcode representation
          Container(height: 50, width: 200, color: Colors.black, child: const Center(child: Text("BARCODE", style: TextStyle(color: Colors.white, letterSpacing: 4)))),
          const SizedBox(height: 4),
          Text("* $code *", style: const TextStyle(color: Colors.black, fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ],
      ),
    );
  }
}
