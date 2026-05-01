import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class LocaleController extends GetxController {
  final GetStorage _storage = GetStorage();

  late Rx<Locale> initialLocale;

  LocaleController() {
    String? savedLang = _storage.read('lang');
    if (savedLang != null) {
      initialLocale = Locale(savedLang).obs;
    } else {
      initialLocale = Locale(Get.deviceLocale?.languageCode ?? 'ar').obs;
    }
  }

  void changeLocale(String langCode) {
    _storage.write('lang', langCode);
    initialLocale.value = Locale(langCode);
    Get.updateLocale(initialLocale.value);
  }
}