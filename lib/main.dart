import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_router.dart';
import 'package:shared_models/shared_models.dart';
import 'package:provider/provider.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart'; // BaseApp tidak digunakan untuk sementara
import 'services/firebase_options.dart';
//import 'screens/attendance/attendance_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeFirebase(
      DefaultFirebaseOptions.currentPlatform);
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    // Anda bisa membungkus dengan BlocProvider di sini
    return ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: BaseApp(
        title: 'Matrix Sphere',
        routerConfig: appRouter,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
