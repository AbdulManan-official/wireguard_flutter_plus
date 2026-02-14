import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep Slate Blue/Black
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF10B981), // Neon Green for connected
      onPrimary: Colors.white,
      secondary: Color(0xFF3B82F6), // Bright Blue for connecting/active
      onSecondary: Colors.white,
      surface: Color(0xFF1E293B), // Lighter Slate for cards
      onSurface: Color(0xFFF8FAFC), // White-ish text
      error: Color(0xFFF43F5E), // Rose red
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE2E8F0)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
    ),
  );
}
