import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundTop = Color(0xFF2B3443);
  static const Color backgroundBottom = Color(0xFF19212C);
  static const Color panel = Color(0xFFF3E9D7);
  static const Color panelSoft = Color(0xFFE7D9C1);
  static const Color accent = Color(0xFFC79B58);
  static const Color accentDeep = Color(0xFF8F6B3D);
  static const Color textPrimary = Color(0xFF20252E);
  static const Color textMuted = Color(0xFF5E6470);
  static const Color boardFrame = Color(0xFF2F251C);
  static const Color boardSection = Color(0xFFF8EFE0);
  static const Color boardSectionLocked = Color(0xFFE0D2BD);
  static const Color boardSectionDraw = Color(0xFFCEC6B8);
  static const Color cellActive = Color(0xFFFFFBF4);
  static const Color cellInactive = Color(0xFFD6D0C4);
  static const Color xMark = Color(0xFFB44642);
  static const Color oMark = Color(0xFF2E5FA8);
  static const Color success = Color(0xFF2E7D4F);
  static const Color warning = Color(0xFF9A6B24);
  static const Color error = Color(0xFFA43D3D);

  // Backward-compatible aliases.
  static const Color darkWood = backgroundBottom;
  static const Color mediumWood = accentDeep;
  static const Color lightWood = panelSoft;
  static const Color activeCell = cellActive;

  const AppColors._();
}
