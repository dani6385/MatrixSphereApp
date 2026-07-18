import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:shared_services/shared_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
//import 'routes/app_router.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Pass all uncaught errors to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const SellerSphere());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class SellerSphere extends StatelessWidget {
  const SellerSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Ganti ke MaterialApp.router
          return MaterialApp.router(
            title: 'Seller Spahere',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            //routerConfig: appRouter, // Gunakan konfigurasi router baru
          );
        },
      ),
    );
  }
}
