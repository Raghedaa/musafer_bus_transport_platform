import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/routes/app_pages/app_page.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';

// SharedPreferences? sharedpref;



void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await AppInitializer.initialize();
  // final storage = FlutterSecureStorage();
  // final token = await storage.read(key: 'token');

  // notificationService.startPolling();

  // runApp( MyApp(token:token));
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {


        // final MyLocaleController localeController = Get.find();

        return GetMaterialApp(

          debugShowCheckedModeBanner: false,
          getPages: AppPages.pages,
          // locale: localeController.currentLocale.value,
          initialRoute: AppRoute.onboarding, // 👈 هون الحل
        );
      },
    );
  }
}
