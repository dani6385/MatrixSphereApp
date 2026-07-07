import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

final ColorScheme darkColorScheme = ColorScheme.dark(
  primary: primary,
  secondary: secondary,
  tertiary: tertiary,
  background: background,
  surface: surface,
  onPrimary: textPrimary,
  onSecondary: textPrimary,
  onTertiary: textPrimary,
  onBackground: textPrimary,
  onSurface: textPrimary,
  surfaceVariant: border,
  onSurfaceVariant: textSecondary,
);

final ColorScheme lightColorScheme = ColorScheme.light(
  primary: secondary,
  secondary: primary,
  tertiary: tertiary,
  background: lightBackground,
  surface: lightSurface,
  onPrimary: lightTextPrimary,
  onSecondary: lightTextPrimary,
  onTertiary: lightTextPrimary,
  onBackground: lightTextPrimary,
  onSurface: lightTextPrimary,
  surfaceVariant: lightBorder,
  onSurfaceVariant: lightTextSecondary,
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
    final colorScheme = darkTheme ? darkColorScheme : lightColorScheme;

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
