import 'package:flutter/material.dart';

class AppTheme {
  // PROD wajib Biru Gelap
  static const Color prodPrimaryColor = Color(0xFF0D1B2A);
  // DEV bebas - pakai teal/green sebagai pembeda
  static const Color devPrimaryColor = Color(0xFF00695C);

  static ThemeData getTheme(String flavor) {
    final isProd = flavor == 'prod';
    final primary = isProd ? prodPrimaryColor : devPrimaryColor;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
