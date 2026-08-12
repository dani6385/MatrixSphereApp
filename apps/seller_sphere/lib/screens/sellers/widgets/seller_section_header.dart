
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerSectionHeader extends StatelessWidget {
  final String title;

  const SellerSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppStyles.headlineSmall.copyWith(
          color: context.onSurface,
        ),
      ),
    );
  }
}