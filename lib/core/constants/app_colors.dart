import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  AppColors._();

  // Primary colors (Teal Brand)
  static const Color primary = Color.fromARGB(255, 0, 150, 136); // Teal 500
  static const Color primaryDark = Color(0xFF00796B); // Teal 700
  static const Color primaryLight = Color(0xFF4DB6AC); // Teal 300

  // Secondary colors (Teal Accent)
  static const Color secondary = Color(0xFF26A69A); // Teal 400
  static const Color secondaryDark = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF80CBC4);

  // Accent colors (Amber - Complementary)
  static const Color accent = Color(0xFFFFC107); // Amber 500
  static const Color accentDark = Color(0xFFFFA000);
  static const Color accentLight = Color(0xFFFFD54F);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);

  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // AI Rating colors
  static const Color ratingExcellent = Color(0xFF10B981); // Green
  static const Color ratingGood = Color(0xFF3B82F6); // Blue
  static const Color ratingAverage = Color(0xFFF59E0B); // Orange
  static const Color ratingPoor = Color(0xFFEF4444); // Red

  // Border colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Shadow color
  static const Color shadow = Color(0x1A000000);
}
