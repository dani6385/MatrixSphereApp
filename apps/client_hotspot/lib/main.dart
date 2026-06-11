import 'package:flutter/foundation.dart' show kIsWeb; // Impor ini penting
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'screens/Dashboard_Screen.dart';


class HotspotLoginScreen extends StatefulWidget {
  const HotspotLoginScreen({super.key});

  @override
  State<HotspotLoginScreen> createState() => _HotspotLoginScreenState();
}

class _HotspotLoginScreenState extends State<HotspotLoginScreen> {
  // Controller dibuat nullable (?) agar bisa bernilai null saat di Web
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();

    // HANYA inisialisasi controller jika BUKAN di Web
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse('http://192.168.20.1/login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MatrixSphere Login")),
      // Gunakan pengecekan platform sebelum menampilkan WebView
      body: kIsWeb 
          ? const Center(child: Text("Mode Web: WebView tidak didukung di sini."))
          : (_controller != null ? WebViewWidget(controller: _controller!) : const SizedBox()),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(), // Ganti home ke DashboardScreen
  ));
}