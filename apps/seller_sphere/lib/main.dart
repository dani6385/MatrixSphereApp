import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/data/dao.dart';
import 'package:seller_sphere/data/database.dart'
    hide ProductDao, TargetDao, TransactionDao;
import 'package:seller_sphere/data/repository.dart';
import 'package:seller_sphere/screens/main_scafold.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  final database = await DatabaseProvider.db.database;
  final repository = AppRepository(
    database.productDao as ProductDao,
    database.transactionDao as TransactionDao,
    database.targetDao as TargetDao,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppViewModel(repository),
      child: const SellerSphereApp(),
    ),
  );
}

class SellerSphereApp extends StatelessWidget {
  const SellerSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller Sphere',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: Provider.of<AppViewModel>(context).isDarkTheme
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MainAppScaffold(),
    );
  }
}
