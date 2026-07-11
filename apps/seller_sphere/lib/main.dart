import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/data/dao.dart';
import 'package:seller_sphere/data/database.dart' hide ProductDao, TransactionDao, TargetDao;
import 'package:seller_sphere/data/repository.dart';
import 'package:seller_sphere/screens/main_scafold.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const SellerSphereApp());
}

class SellerSphereApp extends StatelessWidget {
  const SellerSphereApp({super.key});

  Future<AppRepository> _initRepository() async {
    final database = await DatabaseProvider.db.database;
    final repository = AppRepository(
      database.productDao as ProductDao,
      database.transactionDao as TransactionDao,
      database.targetDao as TargetDao,
    );
    return repository;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppRepository>(
      future: _initRepository(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              ),
            );
          }

          return ChangeNotifierProvider(
            create: (context) => AppViewModel(snapshot.data!),
            child: Consumer<AppViewModel>(
              builder: (context, viewModel, _) {
                return MaterialApp(
                  title: 'Seller Sphere',
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: viewModel.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                  home: const MainAppScaffold(),
                );
              },
            ),
          );
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
