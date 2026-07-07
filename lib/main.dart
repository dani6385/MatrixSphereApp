import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'viewmodels/app_view_model.dart';
import 'screens/main_scaffold.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    return MaterialApp(
      theme: AppTheme.dark,
      home: viewModel.isLoggedIn ? const MainScaffold() : const LoginScreen(),
    );
  }
}