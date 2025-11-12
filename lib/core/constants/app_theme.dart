import 'package:flutter/material.dart';

/// Tema de la aplicación con diseño elegante y profesional
/// Paleta: "Elegancia Azul Marino" - Dark mode con acentos azul marino y dorado
class AppTheme {
  AppTheme._();

  // Colores principales - Elegancia Azul Marino
  static const Color darkBackground = Color(0xFF0F172A); // Azul muy oscuro
  static const Color darkSurface = Color(0xFF1E293B); // Azul oscuro
  static const Color darkCard = Color(0xFF334155); // Azul slate

  // Acentos - Azul Marino y Dorado Elegante
  static const Color primaryCyan = Color(0xFF1E3A8A); // Azul marino profundo (reemplazo de cyan)
  static const Color primaryPurple = Color(0xFF3B82F6); // Azul medio (reemplazo de purple)
  static const Color accentPink = Color(0xFFD4AF37); // Dorado suave
  static const Color accentBlue = Color(0xFF60A5FA); // Azul claro

  // Colores de estado
  static const Color successColor = Color(0xFF10B981); // Verde esmeralda
  static const Color errorColor = Color(0xFFEF4444); // Rojo suave
  static const Color warningColor = Color(0xFFF59E0B); // Ámbar
  static const Color infoColor = Color(0xFF3B82F6); // Azul

  // Colores de texto
  static const Color textPrimary = Color(0xFFF8FAFC); // Blanco nieve
  static const Color textSecondary = Color(0xFFE2E8F0); // Gris perla
  static const Color textHint = Color(0xFF94A3B8); // Gris suave

  // Efectos
  static const Color glowCyan = Color(0xFF3B82F6); // Azul medio para glow
  static const Color glowPurple = Color(0xFFD4AF37); // Dorado para glow

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFFD4AF37)], // Azul a dorado (mejor contraste)
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF334155), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Tema principal
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryCyan,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryCyan,
        secondary: primaryPurple,
        surface: darkSurface,
        error: errorColor,
        onPrimary: darkBackground,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),

      // AppBar con glassmorphism
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
      ),

      // Inputs futuristas
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryCyan.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryCyan.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryCyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryCyan,
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: textHint,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Botones con gradiente
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: glowCyan.withOpacity(0.5),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryCyan,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // FAB futurista
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryCyan,
        foregroundColor: darkBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: primaryCyan.withOpacity(0.2)),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Estilos de texto futuristas
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 1.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 1.2,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle bodyTextSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textHint,
    letterSpacing: 0.5,
  );

  // Sombras con glow effect
  static List<BoxShadow> glowShadow({Color color = glowCyan}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: color.withOpacity(0.1),
        blurRadius: 40,
        offset: const Offset(0, 8),
      ),
    ];
  }

  // Glassmorphism container decoration
  static BoxDecoration glassmorphism({
    double blur = 10,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? darkCard.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: borderColor ?? primaryCyan.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: glowShadow(),
    );
  }
}
