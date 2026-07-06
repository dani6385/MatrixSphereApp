import 'package:flutter/material.dart';

final ColorScheme darkColorScheme = ColorScheme.dark(
  primary: const Color(0xFF00BCD4), // CyanPrimary
  secondary: const Color(0xFF2196F3), // BlueSecondary
  tertiary: const Color(0xFF009688), // TealTertiary
  background: const Color(0xFF1E1E1E), // SlateBackgroundDark
  surface: const Color(0xFF2D2D2D), // SlateSurfaceDark
  onPrimary: const Color(0xFF1E1E1E), // SlateBackgroundDark
  onSecondary: const Color(0xFF1E1E1E), // SlateBackgroundDark
  onTertiary: const Color(0xFF1E1E1E), // SlateBackgroundDark
  onBackground: const Color(0xFFE0E0E0), // TextOnDarkPrimary
  onSurface: const Color(0xFFE0E0E0), // TextOnDarkPrimary
  surfaceVariant: const Color(0xFF3D3D3D), // SlateBorderDark
  onSurfaceVariant: const Color(0xFFB0B0B0), // TextOnDarkSecondary
);

final ColorScheme lightColorScheme = ColorScheme.light(
  primary: const Color(0xFF2196F3), // BlueSecondary
  secondary: const Color(0xFF00BCD4), // CyanPrimary
  tertiary: const Color(0xFF009688), // TealTertiary
  background: const Color(0xFFF5F5F5), // SlateBackgroundLight
  surface: const Color(0xFFFFFFFF), // SlateSurfaceLight
  onPrimary: const Color(0xFFFFFFFF), // SlateSurfaceLight
  onSecondary: const Color(0xFFFFFFFF), // SlateSurfaceLight
  onTertiary: const Color(0xFFFFFFFF), // SlateSurfaceLight
  onBackground: const Color(0xFF212121), // TextOnLightPrimary
  onSurface: const Color(0xFF212121), // TextOnLightPrimary
  surfaceVariant: const Color(0xFFE0E0E0), // SlateBorderLight
  onSurfaceVariant: const Color(0xFF757575), // TextOnLightSecondary
);

class MyApplicationTheme extends StatelessWidget {
  final bool darkTheme;
  final WidgetBuilder content;

  const MyApplicationTheme({
    super.key,
    this.darkTheme = true,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = darkColorScheme;

    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) => content(context),
      ),
    );
  }
}