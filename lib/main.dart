import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musafer/routes/app_pages/app_page.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import 'core/localization/my_locale.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';
import 'core/constants/app_theme.dart';
import 'core/localization/locale_controller.dart';
import 'core/theme/theme_controller.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  await GetStorage.init();


  Get.put(ThemeController(), permanent: true);
  Get.put(LocaleController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final LocaleController localeController = Get.find<LocaleController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Obx(() {
          final box = GetStorage();
          final bool savedTheme = box.read('isDarkMode') ?? false;
          final String? token = box.read('token');
          final bool isFirstTime = box.read('isFirstTime') ?? true;

          return GetMaterialApp(
            title: 'Musafer',
            translations: MyTranslation(),

            locale: localeController.initialLocale.value,

            theme: AppThemes.light,
            darkTheme: AppThemes.dark,

            themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

            initialRoute: (token != null && token.isNotEmpty)
                ? AppRoute.main_layout
                : (isFirstTime ? AppRoute.onboarding : AppRoute.login),

            getPages: AppPages.pages,
            debugShowCheckedModeBanner: false,
          );
        });
      },
    );
  }
}