import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color forestGreen = Color(0xFF375534);
  static const Color sage = Color(0xFF6B9071);
  static const Color lightSage = Color(0xFFAEC3B0);
  static const Color deepestGreen = Color(0xFF0F2A1D);
  static const Color cream = Color(0xFFE3EED4);

  static ThemeData get theme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      fontFamilyFallback: [
        'SF Pro Display',
        'San Francisco',
        'Sequel Pro',
        'Helvetica',
        'Arial',
      ],
      bodyColor: cream,
      displayColor: cream,
    );

    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: forestGreen,
        primary: forestGreen,
        secondary: sage,
        tertiary: lightSage,
        surface: deepestGreen,
        onSurface: cream,
      ),
      scaffoldBackgroundColor: deepestGreen,
      iconTheme: const IconThemeData(color: cream),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: cream),
        titleTextStyle: TextStyle(
          color: cream,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
