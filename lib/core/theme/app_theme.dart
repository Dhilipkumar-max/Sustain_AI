import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors - Teal/Sustainabilit
  static const Color primary50 = Color(0xFFf0fdfa);
  static const Color primary100 = Color(0xFFccfbf1);
  static const Color primary200 = Color(0xFF99f6e4);
  static const Color primary300 = Color(0xFF5eead4);
  static const Color primary400 = Color(0xFF2dd4bf);
  static const Color primary500 = Color(0xFF14b8a6);
  static const Color primary600 = Color(0xFF0d9488);
  static const Color primary700 = Color(0xFF0f766e);
  static const Color primary800 = Color(0xFF115e59);
  static const Color primary900 = Color(0xFF134e4a);

  // Background Colors - Dark Theme
  static const Color bgPrimary = Color(0xFF0f172a);
  static const Color bgSecondary = Color(0xFF1e293b);
  static const Color bgTertiary = Color(0xFF334155);
  static const Color bgCard = Color(0xFF1e293b);
  static const Color bgCardHover = Color(0xFF2d3a4f);
  
  // Background Colors - Light Theme
  static const Color bgLightPrimary = Color(0xFFf8fafc);
  static const Color bgLightSecondary = Color(0xFFffffff);
  static const Color bgLightTertiary = Color(0xFFf1f5f9);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFf8fafc);
  static const Color textSecondary = Color(0xFF94a3b8);
  static const Color textTertiary = Color(0xFF64748b);
  static const Color textMuted = Color(0xFF475569);
  
  // Text Colors - Light Theme
  static const Color textLightPrimary = Color(0xFF0f172a);
  static const Color textLightSecondary = Color(0xFF475569);
  static const Color textLightTertiary = Color(0xFF64748b);
  
  // Semantic Colors
  static const Color success = Color(0xFF22c55e);
  static const Color warning = Color(0xFFf59e0b);
  static const Color danger = Color(0xFFef4444);
  static const Color info = Color(0xFF3b82f6);
  
  // Module Colors
  static const Color teal = Color(0xFF14b8a6);
  static const Color blue = Color(0xFF3b82f6); 
  static const Color pink = Color(0xFFec4899);
  static const Color orange = Color(0xFFf97316);
  static const Color green = Color(0xFF22c55e);
  static const Color purple = Color(0xFF8b5cf6);
  
  // Border Radius
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg =12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 24.0;
  
  // Spacing
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary500,
      scaffoldBackgroundColor: bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: primary500,
        secondary: primary400,
        surface: bgCard,
        background: bgPrimary,
        error: danger,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgSecondary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary600,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary500, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary500,
      scaffoldBackgroundColor: bgLightPrimary,
      colorScheme: const ColorScheme.light(
        primary: primary500,
        secondary: primary400,
        surface: bgLightSecondary,
        background: bgLightPrimary,
        error: danger,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.apply(
          bodyColor: textLightPrimary,
          displayColor: textLightPrimary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLightSecondary,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textLightPrimary,
      ),
      cardTheme: CardThemeData(
        color: bgLightSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: Color(0xFFe2e8f0), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary600,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgLightSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary500, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  // Score Colors
  static Color getScoreColor(double score) {
    if (score >= 80) return success;
    if (score >= 60) return Color(0xFF84cc16);
    if (score >= 40) return warning;
    if (score >= 20) return orange;
    return danger;
  }
  
  // Severity Colors
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return success;
      case 'medium':
        return warning;
      case 'high':
        return orange;
      case 'critical':
      case 'emergency':
        return danger;
      default:
        return info;
    }
  }
}
