import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/auth/auth_bloc.dart';
import 'package:seller_sphere/auth/auth_service.dart';
import 'package:seller_sphere/screens/home/home_page.dart';
import 'package:seller_sphere/screens/inventory/providers/app_provider.dart';
import 'package:seller_sphere/screens/login/login_page.dart';


void main() async {
  // Pastikan semua binding Flutter siap sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyediakan semua BLoC dan Provider yang dibutuhkan di level atas
    return MultiProvider(
      providers: [
        // Menyediakan AuthService ke AuthBloc
        RepositoryProvider(create: (context) => AuthService()),
        // Membuat dan menyediakan AuthBloc
        BlocProvider(
          create: (context) => AuthBloc(
            authService: RepositoryProvider.of<AuthService>(context),
          ),
        ),
        // Menyediakan AppProvider untuk state manajemen produk, dll.
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Seller Sphere',
        theme: ThemeData.dark(), // Menggunakan tema dari shared_ui
        debugShowCheckedModeBanner: false,
        // BlocBuilder untuk merespons perubahan state otentikasi
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              // Jika otentikasi berhasil, tampilkan HomePage
              return const HomePage();
            }
            // Jika tidak, tampilkan LoginPage (termasuk state Initial, Failure, Loading)
            return const LoginPage();
          },
        ),
      ),
    );
  }
}