import 'package:flutter/material.dart';
import '../dialog/qr_dialog.dart';

class QrBottom extends StatefulWidget {
  const QrBottom({super.key});

  @override
  State<QrBottom> createState() => _QrBottomState();
}

class _QrBottomState extends State<QrBottom> {
  String? qrCodeResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hasil Pindai QR Code:',
            ),
            Text(
              qrCodeResult ?? 'Belum ada data',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showQrDialog(context);
          setState(() {
            qrCodeResult = result;
          });
        },
        tooltip: 'Pindai',
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
