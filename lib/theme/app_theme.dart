import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF2B8CEE);
  static const Color backgroundLight = Color(0xFFF6F7F8);
  static const Color backgroundDark = Color(0xFF101922);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A2633); // #1a2632 from HTML, slightly adjusted? HTML says #1a2632 which is 26, 38, 50. Hex: 1A2632.

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primary,
      surface: surfaceLight,
      background: backgroundLight,
      onBackground: Color(0xFF111418), // text-slate-900
    ),
    textTheme: GoogleFonts.lexendTextTheme().copyWith(
      displayLarge: GoogleFonts.lexend(
          color: const Color(0xFF111418), fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.notoSans(color: const Color(0xFF111418)),
      bodyMedium: GoogleFonts.notoSans(color: const Color(0xFF637588)),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: Color(0xFF111418),
        elevation: 0,
        scrolledUnderElevation: 0,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: surfaceDark,
      background: backgroundDark,
      onBackground: Colors.white,
    ),
    textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.lexend(
          color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.notoSans(color: Colors.white),
      bodyMedium: GoogleFonts.notoSans(color: Color(0xFF94A3B8)), // text-slate-400
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
    ),
  );
}
