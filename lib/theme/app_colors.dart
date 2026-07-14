import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Identidad (Verde Profesional)
  static const Color pitchPrimary = Color(0xFF1B4332); // Verde esmeralda profundo
  static const Color pitchPrimaryDark = Color(0xFF0B2018);
  static const Color pitchPrimaryLight = Color(0xFF2D6A4F);
  static const Color pitchPrimaryFaint = Color(0xFFE8F5E9);

  // Fondos y Superficies (Moderno / Blanco)
  static const Color chalk = Color(0xFFF8F9FA); // Blanco grisáceo muy suave
  static const Color chalkSurface = Color(0xFFFFFFFF); // Blanco puro
  static const Color chalkLine = Color(0xFFE9ECEF); // Gris sutil para bordes
  
  static const Color ink = Color(0xFF1B4332); // Texto principal en verde profundo
  static const Color inkMuted = Color(0xFF6C757D); // Gris para info secundaria
  static const Color inkFaint = Color(0xFFADB5BD);

  // Mantenemos nombres antiguos para no romper widgets existentes, pero con nuevos valores claros
  static const Color surfaceDark = Color(0xFFFFFFFF);
  static const Color surfaceDarkAlt = Color(0xFFF1F3F5);
  static const Color lineDark = Color(0xFFE9ECEF);
  static const Color textOnDark = Color(0xFF1B4332);
  static const Color textOnDarkMuted = Color(0xFF6C757D);

  static const Color gold = Color(0xFFC9A227); // Mantenemos el dorado para Premium
  static const Color goldLight = Color(0xFFE3C468);
  static const Color goldSurface = Color(0xFFF7EFD6);

  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFB3781D);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF3A6EA5);

  static const Color positionGoalkeeper = Color(0xFFB3781D);
  static const Color positionDefender = Color(0xFF3A6EA5);
  static const Color positionMidfielder = Color(0xFF3F8F5F);
  static const Color positionForward = Color(0xFFB3261E);
}
