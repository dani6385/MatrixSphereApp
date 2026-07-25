import 'package:flutter/material.dart';

/// Divider dengan gaya kustom dan spasi vertikal.
class StyledDivider extends StatelessWidget {
  const StyledDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 32, // Memberi spasi vertikal 16 atas dan 16 bawah
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
    );
  }
}