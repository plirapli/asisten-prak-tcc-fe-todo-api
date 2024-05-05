import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 70, 216, 189),
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 1.75,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
  ),
  useMaterial3: true,
);
