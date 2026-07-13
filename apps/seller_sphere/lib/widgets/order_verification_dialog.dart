import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'dart:async';

import '../models/shopsphere_order.dart';
import 'order_verification/verification_info_card.dart';
import 'order_verification/verification_tab_selector.dart';
import 'order_verification/manual_verification_view.dart';
import 'order_verification/camera_verification_view.dart';

class OrderVerificationDialog extends StatefulWidget {
  final ShopsphereOrder order;
  final VoidCallback onVerifySuccess;

  const OrderVerificationDialog({
    super.key,
    required this.order,
    required this.onVerifySuccess,
  });

  @override
  OrderVerificationDialogState createState() => OrderVerificationDialogState();
}

class OrderVerificationDialogState extends State<OrderVerificationDialog> {
  int _activeTab = 1; // 1 for camera, 0 for manual
  String _inputCode = "";
  String _errorMessage = "";
  bool _isScanning = false;

  void _onVerify() {
    if (_inputCode == widget.order.verificationCode) {
      widget.onVerifySuccess();
    } else {
      setState(() {
        _errorMessage = "Kode verifikasi salah!";
      });
    }
  }

  void _simulateScan() {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _errorMessage = "";
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() {
        _isScanning = false;
        _inputCode = widget.order.verificationCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kSlateSurfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(children: [Icon(Icons.qr_code, color: kNeonCyan), SizedBox(width: 8), Text("Verifikasi Pengambilan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerificationInfoCard(order: widget.order),
            const SizedBox(height: 12),
            VerificationTabSelector(activeTab: _activeTab, onTabSelected: (tab) => setState(() => _activeTab = tab)),
            const SizedBox(height: 12),
            if (_activeTab == 0)
              ManualVerificationView(
                order: widget.order,
                inputCode: _inputCode,
                isScanning: _isScanning,
                onCodeChanged: (code) => setState(() { _inputCode = code; _errorMessage = ""; }),
                onSimulateScan: _simulateScan,
              )
            else
              CameraVerificationView(
                order: widget.order,
                onBarcodeDetected: (code) {
                  if (code == widget.order.verificationCode) {
                    widget.onVerifySuccess();
                  } else {
                    setState(() => _errorMessage = "Kode salah terdeteksi: $code");
                  }
                },
              ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 11, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal", style: TextStyle(color: Colors.white70))),
        if (_activeTab == 0)
          ElevatedButton(
            onPressed: _inputCode.length == 6 && !_isScanning ? _onVerify : null,
            style: ElevatedButton.styleFrom(backgroundColor: kSoftTeal),
            child: const Text("Konfirmasi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
      ],
    );
  }
}
