import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/theme/app_colors.dart';

// ─────────────────────────────────────────────
// COLOR SCHEMES
// ─────────────────────────────────────────────

class AppColorScheme {
  // =========================
  // 🌞 LIGHT THEME
  // =========================
  static const lightColorScheme = ColorScheme.light(
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightSurface,
    primaryContainer: AppColors.lightControlPressed,
    onPrimaryContainer: AppColors.lightTextPrimary,

    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightSurface,
    secondaryContainer: AppColors.lightProgressBackground,
    onSecondaryContainer: AppColors.lightTextPrimary,

    tertiary: AppColors.lightSecondary,
    onTertiary: AppColors.lightSurface,
    tertiaryContainer: AppColors.lightProgressBackground,
    onTertiaryContainer: AppColors.lightTextPrimary,

    error: Colors.red,
    onError: AppColors.lightSurface,
    errorContainer: AppColors.lightProgressBackground,
    onErrorContainer: AppColors.lightTextPrimary,

    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    surfaceContainerHighest: AppColors.lightBackground,
    onSurfaceVariant: AppColors.lightTextSecondary,

    outline: AppColors.lightProgressBackground,
    outlineVariant: AppColors.lightBackground,

    inverseSurface: AppColors.lightTextPrimary,
    onInverseSurface: AppColors.lightSurface,
    inversePrimary: AppColors.lightControlPressed,

    shadow: Colors.black,
    scrim: Colors.black,
  );

  // =========================
  // 🌙 DARK THEME
  // =========================
  static const darkColorScheme = ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.darkControlPressed,
    onPrimaryContainer: AppColors.darkTextPrimary,

    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkBackground,
    secondaryContainer: AppColors.darkProgressBackground,
    onSecondaryContainer: AppColors.darkTextPrimary,

    tertiary: AppColors.darkSecondary,
    onTertiary: AppColors.darkBackground,
    tertiaryContainer: AppColors.darkProgressBackground,
    onTertiaryContainer: AppColors.darkTextPrimary,

    error: Colors.red,
    onError: AppColors.darkBackground,
    errorContainer: AppColors.darkProgressBackground,
    onErrorContainer: AppColors.darkTextPrimary,

    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkBackground,
    onSurfaceVariant: AppColors.darkTextSecondary,

    outline: AppColors.darkProgressBackground,
    outlineVariant: AppColors.darkBackground,

    inverseSurface: AppColors.darkTextPrimary,
    onInverseSurface: AppColors.darkBackground,
    inversePrimary: AppColors.darkControlPressed,

    shadow: Colors.black,
    scrim: Colors.black,
  );
}

// ─────────────────────────────────────────────
// TEXT THEME
// ─────────────────────────────────────────────

class AppTextTheme {
  static TextTheme textTheme(ColorScheme cs) {
    final primary = cs.onSurface;
    final secondary = cs.onSurfaceVariant;

    return TextTheme(
      // Display
      displayLarge: TextStyle(
        color: primary,
        fontSize: 57,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        color: primary,
        fontSize: 45,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        color: primary,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline
      headlineLarge: TextStyle(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        color: primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title
      titleLarge: TextStyle(
        color: primary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body
      bodyLarge: TextStyle(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label
      labelLarge: TextStyle(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// APP THEME
// ─────────────────────────────────────────────

class AppTheme {
  // ── LIGHT ──────────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColorScheme.lightColorScheme,

    scaffoldBackgroundColor: AppColors.lightBackground,

    textTheme: AppTextTheme.textTheme(AppColorScheme.lightColorScheme),
    primaryTextTheme: AppTextTheme.textTheme(AppColorScheme.lightColorScheme),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.lightPrimary,
      selectionColor: AppColors.lightPrimary.withOpacity(0.3),
      selectionHandleColor: AppColors.lightPrimary,
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: AppBarTheme(
      // actionsPadding: EdgeInsets.symmetric(vertical: 10),
      backgroundColor:AppColors.lightBackground,
      //  AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightProgressBackground, width: 0.5),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightTextSecondary,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.lightPrimary.withOpacity(0.12),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.lightPrimary, size: 22);
        }
        return IconThemeData(color: AppColors.lightTextSecondary, size: 22);
      }),
    ),

    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.darkProgressBackground,
          width: 0.5,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.darkProgressBackground,
          width: 0.5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),

      hintStyle: TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightSurface,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: BorderSide(color: AppColors.lightPrimary),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.lightPrimary),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightProgressBackground,
      selectedColor: AppColors.lightPrimary,
      labelStyle: TextStyle(color: AppColors.lightTextPrimary, fontSize: 12),
    ),

    dividerTheme: DividerThemeData(
      color: AppColors.lightProgressBackground,
      thickness: 0.5,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightTextPrimary,
      contentTextStyle: TextStyle(color: AppColors.lightSurface),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // ── DARK ───────────────────────────────────
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.darkColorScheme,

    scaffoldBackgroundColor: AppColors.darkBackground,

    textTheme: AppTextTheme.textTheme(AppColorScheme.darkColorScheme),
    primaryTextTheme: AppTextTheme.textTheme(AppColorScheme.darkColorScheme),

    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: AppBarTheme(
      backgroundColor:AppColors.darkBackground,
      //  AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.darkProgressBackground, width: 0.5),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.darkTextSecondary,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.darkPrimary.withOpacity(0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.darkPrimary, size: 22);
        }
        return IconThemeData(color: AppColors.darkTextSecondary, size: 22);
      }),
    ),

    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.lightProgressBackground,
          width: 0.5,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.lightProgressBackground,
          width: 0.5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkPrimary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),

      hintStyle: TextStyle(color: AppColors.darkTextSecondary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkBackground,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: BorderSide(color: AppColors.darkPrimary),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.darkPrimary),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkProgressBackground,
      selectedColor: AppColors.darkPrimary,
      labelStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),

    dividerTheme: DividerThemeData(
      color: AppColors.darkProgressBackground,
      thickness: 0.5,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurface,
      contentTextStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
