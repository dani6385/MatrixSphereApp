// ignore_for_file: use_super_parameters

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView extends StatelessWidget {
  final String url;

  const SafeWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // JIKA DI WEB: Tampilkan placeholder agar tidak error
    if (kIsWeb) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.web, size: 50, color: Colors.grey),
              Text("Mode Testing Web: WebView dimatikan."),
              Text("Buka di Emulator/HP untuk melihat login."),
            ],
          ),
        ),
      );
    } 
    
    // JIKA DI ANDROID/IOS: Jalankan WebView asli
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return WebViewWidget(controller: controller);
  }
}