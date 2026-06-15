import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';

class AppColor{
  static const Color darkgreen = Color(0xFF3d4e3c);
  //static const Color black = Color(0xFF0A0909);
  //static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF0000);
  //static const Color grey = Color(0xFF616161);
  static const Color amber = Color(0xFFFFC107);
  static const Color blue = Color(0xFF2196F3);
  static const Color pink = Color(0xFFE91E63);
  static const Color green = Color(0xFF4CAF50);
  static const Color orange = Color(0xFFFF9800);
  static const Color teal = Color(0xFF009688);





  /////////////////////////



  static bool get _isDark => Get.find<ThemeController>().isDarkMode.value;
  static Color get background => _isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF8F9FC);
  static Color get white => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  static Color get black => _isDark ? Colors.white : const Color(0xFF1A1A2E);
  static Color get grey => _isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6C757D);
  static Color get scaffoldBackground => _isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF8F9FC);
  static Color get cardColor => _isDark ? const Color(0xFF2A2A2A) : Colors.white;
  static Color get fillColor => _isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5);

  static Color get black87 => _isDark ? Colors.white70 : Colors.black87;
  static Color get black12 => _isDark ? Colors.white12 : Colors.black12;
  static Color get primaryGrey => _isDark ? Colors.grey.shade400 : Colors.grey;
  static Color get greyText => _isDark ? const Color(0xFFB0B0B0) : const Color(0xFF8E8E8E);
  static Color get lightGrey => _isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE9ECEF);
  static Color get creamLight => _isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFFEBD2);


  static Color get femaleBookedBg => _isDark ? const Color(0xFF4A148C).withOpacity(0.3) : const Color(0xFFFCE4EC);
  static Color get femaleBookedBorder => _isDark ? const Color(0xFFCE93D8) : const Color(0xFFF06292);

  static Color get maleBookedBg => _isDark ? const Color(0xFF0D47A1).withOpacity(0.3) : const Color(0xFFE3F2FD);
  static Color get maleBookedBorder => _isDark ? const Color(0xFF90CAF9) : const Color(0xFF64B5F6);

  static Color get unavailableBg => _isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  static Color get unavailableBorder => _isDark ? const Color(0xFF555555) : const Color(0xFFBDBDBD);


  static Color get primary => _isDark
      ? const Color(0xFF5F7F5C)
      : const Color(0xFF3d4e3c);
  static Color get secondary => _isDark ? darkgreen : const Color(0xFF00C8FF);
// grey[600]

}