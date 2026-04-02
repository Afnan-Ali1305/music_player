// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // 🌞 LIGHT THEME
  // =========================

  static const Color lightPrimary = Color(0xFFFFC107);        // Vibrant Gold/Yellow - Main brand color
  static const Color lightSecondary = Color(0xFFFFB300);      // Muted Amber/Orange - For accents and shading

  static const Color lightBackground = Color(0xFFF5F6FA);     // Kept soft light background (neutral)
  static const Color lightSurface = Color(0xFFFFFFFF);        // White surface

  static const Color lightTextPrimary = Color(0xFF212121);    // Deep Charcoal - For strong contrast on light bg
  static const Color lightTextSecondary = Color(0xFF636E72);  // Kept readable gray

  static const Color lightControl = Color(0xFFFFC107);        // Vibrant Gold for buttons, controls
  static const Color lightControlPressed = Color(0xFFFFB300); // Amber shade for pressed state

  static const Color lightProgressActive = Color(0xFFFFC107); // Gold for progress bars
  static const Color lightProgressBackground = Color(0xFFDFE6E9);

  // =========================
  // 🌙 DARK THEME
  // =========================

  static const Color darkPrimary = Color(0xFFFFC107);         // Vibrant Gold - Stands out beautifully on dark
  static const Color darkSecondary = Color(0xFFFFB300);       // Amber accent

  static const Color darkBackground = Color(0xFF121212);      // Near-black base
  static const Color darkSurface = Color(0xFF1E1E1E);         // Slightly lighter surface

  static const Color darkTextPrimary = Color(0xFFFFFFFF);     // White text for readability
  static const Color darkTextSecondary = Color(0xFFB2BEC3);

  static const Color darkControl = Color(0xFFFFC107);         // Gold controls on dark theme
  static const Color darkControlPressed = Color(0xFFFFB300);  // Amber for pressed state

  static const Color darkProgressActive = Color(0xFFFFC107);  // Gold progress
  static const Color darkProgressBackground = Color(0xFF2D3436);

  // =========================
  // 🎨 EXTRA (COMMON USE)
  // =========================

  static const Color transparent = Colors.transparent;

  // New brand-specific colors from your icon
  static const Color brandGold = Color(0xFFFFC107);           // Main vibrant yellow/gold
  static const Color brandAmber = Color(0xFFFFB300);          // Shading / inner rings
  static const Color brandCharcoal = Color(0xFF212121);       // Music note & deep shadows
  static const Color brandDark = Color(0xFF1E1E1E);           // Useful for dark surfaces
}