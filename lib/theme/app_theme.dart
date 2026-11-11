import 'package:flutter/material.dart';

class AppColors {
  static const Color teal900 = Color(0xFF134E4A);
  static const Color teal800 = Color(0xFF115E59);
  static const Color teal700 = Color(0xFF0F766E);
  static const Color teal600 = Color(0xFF0D9488);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal400 = Color(0xFF2DD4BF);
  static const Color teal100 = Color(0xFFCCFBF1);
  static const Color teal50 = Color(0xFFF0FDFA);

  static const Color gold = Color(0xFFE5AC18);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber600 = Color(0xFFD97706);

  static const Color lightBg = Color(0xFFFDFBF7);
  static const Color darkBg = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1F2937);
  static const Color darkSurface = Color(0xFF374151);

  static const Color rose600 = Color(0xFFE11D48);
  static const Color emerald600 = Color(0xFF059669);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color sky600 = Color(0xFF0284C7);
}

class AppTheme {
  static ThemeData buildTheme({
    required Brightness brightness,
    required String fontFamily,
    required double baseFontSize,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final double scale = baseFontSize / 16.0;
    final String? effectiveFont = fontFamily == 'System' ? null : fontFamily;
    final List<String> fallback = effectiveFont == null
        ? const ['NotoSansArabic', 'NotoSans']
        : const ['NotoSans', 'NotoSansArabic'];

    final Color bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color textColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF1F2937);
    final Color mutedColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563);

    TextStyle style(double size, FontWeight weight, [Color? color]) => TextStyle(
          fontFamily: effectiveFont,
          fontFamilyFallback: fallback,
          fontSize: size * scale,
          fontWeight: weight,
          color: color ?? textColor,
          height: 1.55,
        );

    final textTheme = TextTheme(
      displaySmall: style(26, FontWeight.w800),
      headlineMedium: style(22, FontWeight.w800),
      headlineSmall: style(19, FontWeight.w700),
      titleLarge: style(18, FontWeight.w700),
      titleMedium: style(16, FontWeight.w700),
      titleSmall: style(14, FontWeight.w600),
      bodyLarge: style(16, FontWeight.w400),
      bodyMedium: style(14, FontWeight.w400, mutedColor),
      bodySmall: style(12, FontWeight.w400, mutedColor),
      labelLarge: style(14, FontWeight.w700),
      labelSmall: style(11, FontWeight.w600, mutedColor),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: effectiveFont,
      scaffoldBackgroundColor: bgColor,
      primaryColor: AppColors.teal700,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isDark ? AppColors.teal400 : AppColors.teal700,
        onPrimary: isDark ? AppColors.teal900 : Colors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.teal900,
        error: AppColors.rose600,
        onError: Colors.white,
        surface: cardColor,
        onSurface: textColor,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: isDark ? 0 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        foregroundColor: isDark ? Colors.white : AppColors.teal800,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: style(
          19,
          FontWeight.w800,
          isDark ? AppColors.teal400 : AppColors.teal800,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.teal500, width: 2),
        ),
      ),
    );
  }
}

