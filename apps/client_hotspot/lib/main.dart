import 'package:client_hotspot/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_services/services/rtdb_service.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_services/shared_services.dart';
import '../widgets/custom_error_widget.dart';
import 'providers/device_provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'providers/offer_provider.dart';
import 'providers/session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        hasShownError = false;
      });

      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    // GoRouter.optionURLReflectsImperativeAPIs = true; // This is now the default
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider yang tidak memiliki dependensi
        Provider(create: (_) => RtdbService()),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => MikroTikApiService()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),

        // Provider yang bergantung pada provider lain (SessionProvider -> RtdbService)
        ChangeNotifierProxyProvider<RtdbService, SessionProvider>(
          create: (context) => SessionProvider(context.read<RtdbService>()),
          update: (context, rtdbService, previousSessionProvider) =>
              SessionProvider(rtdbService),
        ),

        // Provider untuk penawaran (OfferProvider -> FirestoreService)
        ChangeNotifierProxyProvider<FirestoreService, OfferProvider>(
          create: (context) => OfferProvider(context.read<FirestoreService>()),
          update: (context, firestoreService, previousOfferProvider) =>
              OfferProvider(firestoreService),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          return MaterialApp.router(
            title: 'mikrologin',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: child!,
                ),
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
