import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      style: const TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textSecondary),
        filled: true,
        fillColor: surface,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primary, width: 1),
        ),
      ),
    );
  }
}
