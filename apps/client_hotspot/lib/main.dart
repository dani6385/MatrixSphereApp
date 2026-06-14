import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'auth/mikrotik_hotspot.dart';

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
                  // TODO: Ganti dengan username/password testing Anda
                  bool success =
                      await MikrotikHotspot.login("user-test", "password-test");

                  if (success) {
                    AppLogger.info("HASIL: Login Berhasil!");
                  } else {
                    AppLogger.warning("HASIL: Login Gagal, cek log di atas.");
                  }
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
