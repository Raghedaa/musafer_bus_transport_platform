import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final GetStorage _storage = GetStorage();

  Locale? initialLocale;

  @override
  void onInit() {
    super.onInit();
    getSavedLocale();
  }

  void getSavedLocale() {
    String? savedLocale = _storage.read('lang');
    if (savedLocale == 'ar') {
      initialLocale = const Locale('ar');
    } else {
      initialLocale = const Locale('en');
    }
  }

  void changeLocale(String langCode) {
    Locale locale = Locale(langCode);
    _storage.write('lang', langCode);
    Get.updateLocale(locale);
  }
}