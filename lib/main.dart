import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'viewmodels/app_view_model.dart';
import 'screens/login_screen.dart';
import 'package:shared_services/shared_service.dart'; // Assuming this path

void main() {
  final firestoreService = FirestoreService(); // Instantiate FirestoreService
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppViewModel(firestoreService), // Pass the service here
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
      home: viewModel.isLoggedIn ? const LoginScreen() : const LoginScreen(),
    );
  }
}