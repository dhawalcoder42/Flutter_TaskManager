import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Colors
  static const Color primaryColor = Color(0xFF5E35B1);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFB00020);

  // Priority colors
  static const Color lowPriorityColor = Color(0xFF4CAF50);
  static const Color mediumPriorityColor = Color(0xFFFFC107);
  static const Color highPriorityColor = Color(0xFFFF9800);
  static const Color urgentPriorityColor = Color(0xFFF44336);

  // Status colors
  static const Color pendingStatusColor = Color(0xFF9E9E9E);
  static const Color inProgressStatusColor = Color(0xFF2196F3);
  static const Color completedStatusColor = Color(0xFF4CAF50);
  static const Color archivedStatusColor = Color(0xFF607D8B);

  // Text styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );

  // Theme data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
