import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'config/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State untuk mengontrol mode gelap/terang
  bool _isDarkMode = true;

  // Di masa mendatang, Anda dapat menambahkan fungsi di sini untuk mengubah _isDarkMode
  // dan mengganti tema aplikasi secara dinamis.

  @override
  Widget build(BuildContext context) {
    // Menggunakan satu MaterialApp.router sebagai akar aplikasi
    return MaterialApp.router(
      // Menggunakan router aplikasi Anda
      routerConfig: router,

      // Mengatur tema terang
      theme: getAppTheme(false),

      // Mengatur tema gelap
      darkTheme: getAppTheme(true),

      // Menentukan mode tema yang akan digunakan berdasarkan state _isDarkMode
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Menghilangkan banner debug
      debugShowCheckedModeBanner: false,
    );
  }
}
