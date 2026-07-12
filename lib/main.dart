import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'viewmodels/app_view_model.dart';
import 'screens/login_screen.dart';
import 'screens/main_scaffold.dart';
import 'package:shared_services/shared_services.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final firestoreService = FirestoreService();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppViewModel(firestoreService),
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
      home: viewModel.isLoggedIn ? const MainAppScaffold() : const LoginScreen(),
    );
  }
}
