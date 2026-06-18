import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../services/hotspot_user.dart'; // Pastikan path ini benar

class HotspotScreen extends StatefulWidget {
  const HotspotScreen({super.key});

  @override
  State<HotspotScreen> createState() => _HotspotScreenState();
}

class _HotspotScreenState extends State<HotspotScreen> {
  // Inisialisasi service
  final HotspotUser _service = HotspotUser();
  String? myIp;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
  }

  // Fungsi untuk mendapatkan IP perangkat secara otomatis
  Future<void> _initNetworkInfo() async {
    final info = NetworkInfo();
    String? ip = await info.getWifiIP();
    if (mounted) {
      setState(() {
        myIp = ip;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading sampai IP didapat
    if (myIp == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Status Perangkat")),
      body: StreamBuilder(
        // Menggunakan service HotspotUser yang sudah kita buat
        stream: _service.getActiveHosts("MatrixSphere", myIp!).onValue,
        builder: (context, snapshot) {
          // Cek loading stream
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Cek jika tidak ada data
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text("Perangkat tidak terdaftar/aktif."));
          }

          // Parsing data dari Firebase
          Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
          var deviceData = data.values.first; // Mengambil objek pertama

          String macAddress = deviceData['mac'] ?? "Data tidak tersedia";
          String ipAddress = deviceData['ip'] ?? "0.0.0.0";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("IP Address : $ipAddress", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("MAC Address: $macAddress", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Status     : Aktif", style: TextStyle(fontSize: 18, color: Colors.green)),
              ],
            ),
          );
        },
      ),
    );
  }
}