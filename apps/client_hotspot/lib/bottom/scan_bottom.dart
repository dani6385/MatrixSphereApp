import 'package:flutter/material.dart';
import '../dialog/scan_dialog.dart';

class ScanBottom extends StatefulWidget {
  const ScanBottom({super.key});

  @override
  State<ScanBottom> createState() => _ScanBottomState();
}

class _ScanBottomState extends State<ScanBottom> {
  String? _scanResult;

  Future<void> _initiateScan() async {
    // Panggil dialog scan dan tunggu hasilnya.
    final String? result = await showScanDialog(context);

    // Jika dialog memberikan hasil (tidak dibatalkan),
    // perbarui state untuk menampilkan hasilnya.
    if (result != null) {
      setState(() {
        _scanResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemindai Kode'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hasil Pindaian:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _scanResult ?? 'Belum ada kode yang dipindai',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _initiateScan,
        tooltip: 'Pindai',
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Pindai Kode'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
