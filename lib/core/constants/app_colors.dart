import 'package:flutter/material.dart';

/// [AppColors] defines the color palette for the Cougar Aviation Academy application.
/// Inspired by premium aviation aesthetics: deep space navy, aviation gold, and crisp whites.
class AppColors {
  AppColors._();

  // Background & Surface
  static const Color background = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF111827);
  static const Color card = Color(0xFF1C2333);

  // Primary & Accent
  static const Color primary = Color(0xFF1E3A5F);
  static const Color accent = Color(0xFFC9A84C);
  static const Color accentLight = Color(0xFFF0D080);

  // Functional
  static const Color danger = Color(0xFFC0392B);
  static const Color success = Color(0xFF1E8449);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E9BAE);
  static const Color textMuted = Color(0xFF4B5563);

  // Borders & Dividers
  static const Color border = Color(0xFF2D3748);
  static const Color divider = Color(0xFF1F2937);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF0F172A)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  static  LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white10,
      Colors.white.withOpacity(0.05),
    ],
  );
}
