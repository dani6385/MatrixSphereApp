
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/core/utils/constants.dart';
//import 'package:seller_sphere/core/utils/size_config.dart';

class SettingMenuTile extends StatelessWidget {
  const SettingMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = kDarkTextPrimary,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(15),
          horizontal: getProportionateScreenWidth(15),
        ),
        decoration: BoxDecoration(
          color: kDarkSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: getProportionateScreenWidth(24),
            ),
            SizedBox(width: getProportionateScreenWidth(15)),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: getProportionateScreenWidth(16),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: getProportionateScreenWidth(18),
            ),
          ],
        ),
      ),
    );
  }
}
