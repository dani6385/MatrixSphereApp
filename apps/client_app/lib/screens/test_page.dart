import 'package:flutter/material.dart'; // Untuk Widget (Scaffold, ElevatedButton, dll)
import 'package:shared_services/shared_services.dart'; // Import package shared_services Anda
import 'package:shared_services/di/service_locator.dart'; // Import file locator (tempat getIt berada)

class TestPage extends StatelessWidget {
  final _mikrotik = getIt<MikrotikService>();

  void _checkConnection(BuildContext context) async {
    bool connected = await _mikrotik.testConnection();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(connected ? "Terhubung ke Router!" : "Koneksi Gagal!"),
          backgroundColor: connected ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _checkConnection(context),
          child: const Text("Cek Koneksi MikroTik"),
        ),
      ),
    );
  }
}
