import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_services/shared_services.dart'; 
import '../widgets/admin_widgets.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // RealTime sekarang diambil dari package shared_services
        ChangeNotifierProvider(create: (_) => RealTime()),
      ],
      child: const MaterialApp(
        home: AdminWidgets(),
      ),
    );
  }
}