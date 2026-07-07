import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_theme.dart';
import '/config/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MyApplicationTheme(
      darkTheme: _isDarkMode,
      content: (context) => MaterialApp.router(routerConfig: router),
    );
  }
}
