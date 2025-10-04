import 'package:flutter/material.dart';

/// Paleta de cores do aplicativo RPG Companion
class AppColors {
  AppColors._();

  // Cores principais da paleta
  static const Color primary = Color(0xFF31465E);
  static const Color secondary = Color(0xFF233243);
  static const Color tertiary = Color(0xFFE0E0E0);
  static const Color buttonColor = Color(0xFF2A3C50);
  static const Color success = Color(0xFF94C25B);
  static const Color fail = Color(0xFFA3293F);

  // Cores derivadas
  static const Color primaryLight = Color(0xFF4A5F7A);
  static const Color primaryDark = Color(0xFF1F2937);
  static const Color secondaryLight = Color(0xFF374151);
  static const Color secondaryDark = Color(0xFF111827);

  // Cores neutras
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);

  // Cores de texto
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Cores funcionais
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color disabled = Color(0xFFD1D5DB);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x3D000000);

  // RPG specific colors
  static const Color diceColor = Color(0xFF94C25B);
  static const Color criticalHit = Color(0xFFFFD700);
  static const Color criticalFail = Color(0xFFA3293F);
  static const Color magicColor = Color(0xFF8B5CF6);
  static const Color healthColor = Color(0xFFEF4444);
  static const Color manaColor = Color(0xFF3B82F6);
  static const Color experienceColor = Color(0xFF10B981);
}
