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

// SharedPreferences? sharedpref;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();

  await GetStorage.init();

  final themeController = Get.put(ThemeController(), permanent: true);
  final localeController = Get.put(LocaleController(), permanent: true);



  runApp(MyApp(localeController: localeController, themeController: themeController));
}


class MyApp extends StatelessWidget {
  final LocaleController localeController;
  final ThemeController themeController;
  final String? token;
  const MyApp({super.key, this.token,required this.localeController, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {


        // final MyLocaleController localeController = Get.find();

        return Obx(() => GetMaterialApp(
          translations: MyTranslation(),
          locale: localeController.initialLocale.value,
          // supportedLocales: const [
          //   Locale('ar'),
          //   Locale('en'),
          // ],
          // localizationsDelegates: const [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: themeController.theme,
          getPages: AppPages.pages,
          initialRoute: AppRoute.onboarding,
        ));
      },
    );
  }
}
