import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:musafer/routes/app_pages/app_page.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import 'core/localization/my_locale.dart';
import 'core/services/api_service.dart';
import 'core/services/notification_service.dart';
import 'data/repositories/booking_repository.dart';
import 'firebase_options.dart';
import 'core/constants/app_theme.dart';
import 'core/localization/locale_controller.dart';
import 'core/theme/theme_controller.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  await initializeDateFormatting('ar_SA', null);
  timeago.setLocaleMessages('ar', timeago.ArMessages());



  Get.put(ApiService(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(LocaleController(), permanent: true);
  Get.put(BookingRepository(), permanent: true);



  // final box = GetStorage();
  // box.write('token', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3N5cmlhLXRyYXZlbC5hcHAvYXBpL2F1dGgvb3RwL2xvZ2luIiwiaWF0IjoxNzgwMjM2NDY4LCJleHAiOjE3OTU3ODg0NjgsIm5iZiI6MTc4MDIzNjQ2OCwianRpIjoiNUJFTEtDbGRRWGx2QXVUWiIsInN1YiI6IjIyIiwicHJ2IjoiYmI2NWQ5YjhmYmYwZGE5ODI3YzhlZDIzMWQ5YzU0YzgxN2YwZmJiMiJ9.yhF5nuP3Md9Tc19uk-YcEVq5QrLSXweICGbfhWVRk9U');


  await Hive.initFlutter();
  await Hive.openBox('popular_trips_box');
  await Hive.openBox('trip_details_box');
  await Hive.openBox('cities_box');
  await Hive.openBox('rest_areas_box');
  await Hive.openBox('stations_box');
  await Hive.openBox('bookings_box');
  await Hive.openBox('booking_details_box');
  await Hive.openBox('user_box');
  await Hive.openBox('notifications_box');
  await Hive.openBox('subscription_box');
  await Hive.openBox('promo_box');
  await Hive.openBox('my_subs');
  await Hive.openBox('complaints_box');


// الآن يمكنك استخدام الصناديق بأمان
  final box = Hive.box('trip_details_box');
  final keys = box.keys.toList();
  for (var key in keys) {
    final value = box.get(key);
    if (value is Map) {
      await box.put(key, jsonEncode(value));
    }
  }

  final citiesBox = Hive.box('cities_box');
  final oldCities = citiesBox.get('cities_list');
  if (oldCities != null && oldCities is List) {
    await citiesBox.put('cities_list', jsonEncode(oldCities));
    print("✅ تم ترقية بيانات المدن إلى JSON string");
  }


  await NotificationService.initialize();

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
          final String? expiryStr = box.read('expiry_date');
          final bool isFirstTime = box.read('isFirstTime') ?? true;

          String initialRoute;

          if (token != null && token.isNotEmpty && expiryStr != null) {
            DateTime expiryDate = DateTime.parse(expiryStr);
            if (DateTime.now().isBefore(expiryDate)) {
              initialRoute = AppRoute.main_layout;
            } else {
              box.remove('token');
              initialRoute = AppRoute.login;
            }
          } else {
            initialRoute = isFirstTime ? AppRoute.onboarding : AppRoute.login;
          }

          return GetMaterialApp(
            title: 'Musafer',
            translations: MyTranslation(),
            locale: localeController.initialLocale.value,

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],

            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

            initialRoute: initialRoute,
            getPages: AppPages.pages,
            debugShowCheckedModeBanner: false,
          );
        });
      },
    );
  }
}