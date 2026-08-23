//import 'dart:ui';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:provider/provider.dart';
import 'package:seller_sphere/navigations/app_router.dart';
//import 'package:seller_sphere/providers/app_provider.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeFirebase(
    DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SellerSphere());
}

class SellerSphere extends StatelessWidget {
  const SellerSphere({super.key});

  @override
  Widget build(BuildContext context) {
    // Anda bisa membungkus dengan BlocProvider di sini
    return BaseApp(
      title: 'Seller Sphere',
      routerConfig: appRouter,
      themeMode: ThemeMode.system,
    );
  }
}

