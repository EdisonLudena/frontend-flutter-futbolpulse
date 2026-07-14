import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Fuente para Números Grandes y Marcadores (Estilo Deportivo)
  static TextStyle scoreboard({double size = 48, Color? color}) => GoogleFonts.bebasNeue(
        fontSize: size,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: color ?? AppColors.pitchPrimary,
      );

  // Fuente para Títulos de Secciones
  static TextStyle sectionTitle({Color? color}) => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: color ?? AppColors.pitchPrimary.withOpacity(0.6),
      );

  static TextTheme buildTextTheme({
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return GoogleFonts.montserratTextTheme().copyWith(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: primaryTextColor,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: primaryTextColor,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}
