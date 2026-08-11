<<<<<<< HEAD

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
=======

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
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
}