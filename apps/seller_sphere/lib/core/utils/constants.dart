import 'package:flutter/material.dart';

import 'package:shared_ui/shared_ui.dart';

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = 812.0; // Based on iPhone 8 Plus
  // 812 is the layout height that designer use
  return (inputHeight / screenHeight) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = 375.0; // Based on iPhone 8 Plus
  // 375 is the layout width that designer use
  return (inputWidth / screenWidth) * screenWidth;
}

// Colors

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kWarmOrange, kVividOrchid],
);
const kAnimationDuration = Duration(milliseconds: 200);
