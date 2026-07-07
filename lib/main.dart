import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'viewmodels/app_view_model.dart';
import 'screens/login_screen.dart';
import 'screens/main_scaffold.dart';

void main() {
  // Inisialisasi service provider
  final services = ServicesProvider.instance;

  runApp(MyApp(services: services));
}

class MyApp extends StatelessWidget {
  final ServicesProvider services;

  const MyApp({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Buat AppViewModel dengan menyuntikkan FirestoreService
      create: (context) => AppViewModel(services.firestoreService),
      child: MaterialApp(
        title: 'Flutter Admin Panel',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        home: Consumer<AppViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.isLoggedIn
                ? const MainAppScaffold()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
