import 'dart:ui';

import 'package:flutter/material.dart';

Color darkbrown = const Color.fromARGB(255, 53, 30, 14);
Color darkBrown = const Color(0xFF4B2E05);
Color lightBrown = const Color(0xFFD2B48C);
Color whiteColor = Colors.white;
Color greyColor = Colors.grey.shade400;
Color rejectedRed = Colors.red.shade700;
Color greenColor = const Color.fromARGB(255, 218, 233, 198);
Color lightred = const Color.fromARGB(255, 231, 193, 193);
// Define these somewhere in your constants file:
const Gradient kDarkBrownGradient = LinearGradient(
  colors: [Color(0xFF4B2E05), Color.fromARGB(255, 114, 43, 10)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const Gradient kLightBrownGradient = LinearGradient(
  colors: [Color.fromARGB(255, 106, 38, 11), Color.fromARGB(255, 182, 70, 19)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const Gradient kButtonGradient = LinearGradient(
  colors: [Color.fromARGB(255, 80, 37, 6), Color(0xFF4B2E05)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
