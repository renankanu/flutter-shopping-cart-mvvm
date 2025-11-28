import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final theme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.black,
    ),
  );
}
