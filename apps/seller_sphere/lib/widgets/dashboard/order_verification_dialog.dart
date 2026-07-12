import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/widgets/dashboard/camera_scanner.dart';

class OrderVerificationDialog extends StatefulWidget {
  final ShopsphereOrder order;
  final VoidCallback onVerifySuccess;

  const OrderVerificationDialog(
      {super.key, required this.order, required this.onVerifySuccess});

  @override
  _OrderVerificationDialogState createState() =>
      _OrderVerificationDialogState();
}

class _OrderVerificationDialogState extends State<OrderVerificationDialog> {
  int _activeTab = 1; // 1 for camera, 0 for manual
  String _inputCode = '';
  String _errorMessage = '';
  bool _isSimulatingScan = false;

  void _verify() {
    if (_inputCode == widget.order.verificationCode) {
      widget.onVerifySuccess();
    } else {
      setState(() {
        _errorMessage =
            "Kode verifikasi salah! Cocokkan barcode atau ketik 6-digit kode pembeli.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Row(children: [
        Icon(Icons.qr_code, color: Color(0xFF00FFFF)),
        SizedBox(width: 8),
        Text("Verifikasi Pengambilan", style: TextStyle(fontSize: 18)),
      ]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: 12),
            _buildTabSelector(),
            const SizedBox(height: 12),
            if (_activeTab == 0) _buildManualTab() else _buildCameraTab(),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal")),
        if (_activeTab == 0)
          ElevatedButton(
            onPressed: _inputCode.length == 6 && !_isSimulatingScan
                ? _verify
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.black,
            ),
            child: const Text("Konfirmasi"),
          ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pesanan: ${widget.order.id}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FFFF))),
            Text("Pelanggan: ${widget.order.customerName}",
                style: const TextStyle(fontSize: 12)),
            Text(
                "Produk: ${widget.order.productName} x${widget.order.quantity}",
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        Expanded(
          flex: 12,
          child: _TabButton(
            text: "Kamera Real-time 📷",
            isSelected: _activeTab == 1,
            onTap: () => setState(() => _activeTab = 1),
          ),
        ),
        Expanded(
          flex: 10,
          child: _TabButton(
            text: "Manual & Simulasi",
            isSelected: _activeTab == 0,
            onTap: () => setState(() => _activeTab = 0),
          ),
        ),
      ],
    );
  }

  Widget _buildManualTab() {
    return Column(
      children: [
        const Text(
          "Gunakan barcode pembeli atau ketik kode verifikasi 6-digit untuk memastikan penyerahan pesanan yang sah.",
          style: TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Simulated barcode
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Simplified barcode representation
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ... a few lines to represent a barcode
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "* ${widget.order.verificationCode} *",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_isSimulatingScan)
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 16,
                  height: 16,
                  child:
                      CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 8),
              Text("Memindai Barcode...", style: TextStyle(fontSize: 12)),
            ],
          )
        else
          TextField(
            controller: TextEditingController(text: _inputCode)
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: _inputCode.length)),
            onChanged: (value) {
              if (value.length <= 6) {
                setState(() {
                  _inputCode = value;
                  _errorMessage = '';
                });
              }
            },
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
                labelText: "Kode Verifikasi (6 Digit)",
                counterText: '',
                isDense: true,
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null),
          ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _isSimulatingScan
              ? null
              : () async {
                  setState(() {
                    _isSimulatingScan = true;
                    _errorMessage = '';
                  });
                  await Future.delayed(const Duration(milliseconds: 1800));
                  setState(() {
                    _inputCode = widget.order.verificationCode;
                    _isSimulatingScan = false;
                  });
                  _verify();
                },
          icon: const Icon(Icons.qr_code, size: 16),
          label: const Text("Simulasi Scan Barcode 📸", style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildCameraTab() {
    return CameraScanner(
      onBarcodeDetected: (code) {
        if (code == widget.order.verificationCode) {
          widget.onVerifySuccess();
        } else {
          setState(() {
            _errorMessage = "Kode salah. Coba lagi.";
          });
        }
      },
      onError: (message) => setState(() => _errorMessage = message),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton(
      {required this.text,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF334155)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00FFFF) : Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
