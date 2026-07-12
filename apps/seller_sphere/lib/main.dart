import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/data/app_repository.dart';
import 'package:seller_sphere/data/dao.dart';
import 'package:seller_sphere/screens/dashboard_screen.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Create the database and repository
  final database = await AppDatabase.create();
  final repository = AppRepository(database: database);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final AppRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppViewModel(repository: repository),
      child: MaterialApp(
        title: 'Seller Sphere',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DashboardScreen(
          onNavigateToInventory: () {},
          onNavigateToTransactions: () {},
          onNavigateToChat: (String customer) {},
          onNavigateToSlides: () {},
        ),
      ),
    );
  }
}
