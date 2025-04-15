import 'package:flutter/material.dart';

final ThemeData petTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
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