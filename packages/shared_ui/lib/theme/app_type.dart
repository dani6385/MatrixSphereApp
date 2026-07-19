import 'package:flutter/material.dart';

// Set of Material typography styles to start with
const TextTheme appTypography = TextTheme(
  bodyLarge: TextStyle(
    fontFamily: 'Roboto', // Default font family in Flutter
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    height: 24.0 / 16.0, // lineHeight / fontSize ratio
    letterSpacing: 0.5,
  ),
  // Other default text styles to override
  titleLarge: TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 22.0,
    height: 28.0 / 22.0,
    letterSpacing: 0.0,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500, // Medium weight
    fontSize: 11.0,
    height: 16.0 / 11.0,
    letterSpacing: 0.5,
  ),
);
