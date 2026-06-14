import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Client Hotspot'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hello, World!'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // TODO: Implementasikan atau impor logika MikrotikHotspot.login
                  // Contoh:
                  // bool success = await MikrotikHotspot.login("username_anda", "password_anda");
                  // if (success) {
                  //   AppLogger.info("HASIL: Login Berhasil!");
                  // } else {
                  //   AppLogger.warning("HASIL: Login Gagal, cek log di atas.");
                  // }
                  AppLogger.info("Tombol Test Login MikroTik ditekan!");
                },
                child: const Text("Test Login MikroTik"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
