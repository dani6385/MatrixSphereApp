import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/auth/auth_bloc.dart';
import 'package:seller_sphere/auth/auth_service.dart';
import 'package:seller_sphere/screens/inventory/providers/app_provider.dart';


void main() async {
  // Pastikan semua binding Flutter siap sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp();
  runApp(const SellerSphere());
}

class SellerSphere extends StatefulWidget {
  const SellerSphere({super.key});

  @override
  State<SellerSphere> createState() => _SellerSphereState();
}

class _SellerSphereState extends State<SellerSphere> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authService: AuthService());
    _router = appRouter;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp.router(
        title: 'Seller Sphere',
        theme: ThemeData.dark(), // Menggunakan tema dari shared_ui
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}