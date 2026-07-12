import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/widgets/dashboard/camera_scanner.dart';

class OrderVerificationDialog extends StatefulWidget {
  final ShopsphereOrder order;
  final VoidCallback onVerifySuccess;

  const OrderVerificationDialog({
    super.key,
    required this.order,
    required this.onVerifySuccess,
  });

  @override
  State<OrderVerificationDialog> createState() => _OrderVerificationDialogState();
}

class _OrderVerificationDialogState extends State<OrderVerificationDialog> with TickerProviderStateMixin {
  int activeTab = 1; // 1 for camera, 0 for manual
  String inputCode = "";
  String errorMessage = "";
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Row(
        children: [
          Icon(Icons.qr_code, color: Color(0xFF00FFFF), size: 24),
          SizedBox(width: 8),
          Text("Verifikasi Pengambilan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: 12),
            _buildTabSelector(),
            const SizedBox(height: 12),
            if (activeTab == 0) _buildManualTab()
            else _buildCameraTab(),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
        if (activeTab == 0)
          ElevatedButton(
            onPressed: (isScanning || inputCode.length != 6) ? null : _verifyCode,
            child: const Text("Konfirmasi Penyerahan", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  void _verifyCode() {
    if (inputCode == widget.order.verificationCode) {
      widget.onVerifySuccess();
    } else {
      setState(() {
        errorMessage = "Kode verifikasi salah! Cocokkan barcode atau ketik 6-digit kode pembeli.";
      });
    }
  }

  Widget _buildOrderInfo() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(128), // 0.5 alpha
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pesanan: ${widget.order.id}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00FFFF))),
            Text("Pelanggan: ${widget.order.customerName}", style: const TextStyle(fontSize: 12)),
            Text("Produk: ${widget.order.productName} x${widget.order.quantity}", style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => setState(() => activeTab = 1),
            style: TextButton.styleFrom(
              backgroundColor: activeTab == 1 ? const Color(0xFF334155) : Colors.transparent,
            ),
            child: Text("Kamera Real-time ???", style: TextStyle(color: activeTab == 1 ? const Color(0xFF00FFFF) : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => setState(() => activeTab = 0),
            style: TextButton.styleFrom(
              backgroundColor: activeTab == 0 ? const Color(0xFF334155) : Colors.transparent,
            ),
            child: Text("Manual & Simulasi", style: TextStyle(color: activeTab == 0 ? const Color(0xFF00FFFF) : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildManualTab() {
    return Column(
      children: [
        const Text("Gunakan barcode pembeli atau ketik kode verifikasi 6-digit untuk memastikan penyerahan pesanan yang sah.",
            style: TextStyle(fontSize: 11)),
        const SizedBox(height: 12),
        // Simulated Barcode Section
        Container(
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Barcode lines would be complex to draw perfectly, so we use a placeholder
              const Text("||| || ||| | ||||", style: TextStyle(fontSize: 40, color: Colors.black)),
              Text("* ${widget.order.verificationCode} *",
                  style: const TextStyle(color: Colors.black, fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (isScanning)
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 8),
              Text("Memindai Barcode Pembeli...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00FFFF))),
            ],
          )
        else
          TextField(
            onChanged: (value) {
              if (value.length <= 6) {
                setState(() {
                  inputCode = value;
                  errorMessage = "";
                });
              }
            },
            controller: TextEditingController(text: inputCode),
            decoration: InputDecoration(
              labelText: "Kode Verifikasi (6 Digit)",
              hintText: "Contoh: ${widget.order.verificationCode}",
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isScanning
              ? null
              : () async {
                  setState(() {
                    isScanning = true;
                    errorMessage = "";
                  });
                  await Future.delayed(const Duration(milliseconds: 1800));
                  setState(() {
                    isScanning = false;
                    inputCode = widget.order.verificationCode;
                  });
                },
          icon: const Icon(Icons.qr_code, size: 16),
          label: const Text("Simulasi Scan Barcode ???", style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildCameraTab() {
    return CameraScanner(
      onBarcodeDetected: (scannedCode) {
        final cleaned = scannedCode.trim();
        if (cleaned == widget.order.verificationCode) {
          widget.onVerifySuccess();
        } else {
          setState(() {
            errorMessage = "Terdeteksi kode: '$cleaned'. (Pesanan ini memerlukan: '${widget.order.verificationCode}')";
          });
        }
      },
      onError: (error) {
        setState(() {
          errorMessage = error;
        });
      },
    );
  }
}
