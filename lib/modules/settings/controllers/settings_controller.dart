// lib/modules/settings/controllers/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/theme_controller.dart';

class SettingsController extends GetxController {
  final LocaleController _localeController = Get.find<LocaleController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  void changeLanguage(String langCode) {
    _localeController.changeLocale(langCode);
  }
}