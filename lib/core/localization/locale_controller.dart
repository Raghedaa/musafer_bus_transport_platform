import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final GetStorage _storage = GetStorage();

  var initialLocale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    getSavedLocale();
  }

  void getSavedLocale() {
    String? savedLocale = _storage.read('lang');
    if (savedLocale == 'ar') {
      initialLocale.value = const Locale('ar');
    } else {
      initialLocale.value = const Locale('en');
    }
    Get.updateLocale(initialLocale.value);
  }

  void changeLocale(String langCode) {
    Locale locale = Locale(langCode);
    _storage.write('lang', langCode);
    initialLocale.value = locale;
    Get.updateLocale(locale);
  }
}