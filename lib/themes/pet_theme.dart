import 'package:flutter/material.dart';
Map<int, Color> colorCodes = {
  50: Color.fromARGB(255, 65, 24, 1),
  100: Color.fromARGB(255, 65, 24, 1),
  200: Color.fromARGB(255, 65, 24, 1),
  300: Color.fromARGB(255, 65, 24, 1),
  400: Color.fromARGB(255, 65, 24, 1),
  500: Color.fromARGB(255, 65, 24, 1),
  600: Color.fromARGB(255, 65, 24, 1),
  700: Color.fromARGB(255, 65, 24, 1),
  800: Color.fromARGB(255, 65, 24, 1),
  900: Color.fromARGB(255, 65, 24, 1),
};
MaterialColor customSwatch = MaterialColor(0xFF411801, colorCodes);
final ThemeData petTheme = ThemeData(
    useMaterial3: true,
     primarySwatch: customSwatch,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 255, 155, 4),
      // ···
      brightness: Brightness.light,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    buttonTheme: const ButtonThemeData(

    ) ,
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
      ),
      bodyLarge: TextStyle(
        fontSize: 20,
      ),
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      )
    ),
  );