import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // أضف استيراد فايربيس
import '../services/notification_service.dart';

class LocaleController extends GetxController {
  final GetStorage _storage = GetStorage();
  late Rx<Locale> initialLocale;

  final RxString currentLang = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    String savedLang = _storage.read('lang') ?? 'ar';
    initialLocale = Locale(savedLang).obs;
    currentLang.value = savedLang;
  }

  void changeLocale(String langCode) async {
    Locale newLocale = Locale(langCode);
    initialLocale.value = newLocale;
    currentLang.value = langCode;
    _storage.write('lang', langCode);
    Get.updateLocale(newLocale);

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await NotificationService.sendTokenToServer(token);
      }
    } catch (e) {
      debugPrint("❌ Failed to update token language: $e");
    }
  }
}