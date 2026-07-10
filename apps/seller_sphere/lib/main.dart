
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/main_shell.dart';
import 'package:seller_sphere/viewmodels/app_viewmodel.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(appViewModelProvider.select((vm) => vm.isDarkTheme));
    return MaterialApp(
      title: 'Seller Sphere',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      home: const MainShell(),
    );
  }
}
