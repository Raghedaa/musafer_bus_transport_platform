
import 'package:get/get.dart';
import 'package:musafer/modules/auth/forget_password/binding/forget_password_binding.dart';
import 'package:musafer/modules/auth/forget_password/views/screen/reset_password_screen.dart';
import 'package:musafer/modules/auth/login/bindings/login_binding.dart';
import 'package:musafer/modules/auth/login/views/screen/login_screen.dart';
import 'package:musafer/modules/auth/verification/bindings/verification_binding.dart';
import 'package:musafer/modules/main_layout/view/screen/main_layout_screen.dart';
import 'package:musafer/modules/on_boarding/bindings/onboarding_binding.dart';
import 'package:musafer/modules/on_boarding/views/screen/onboarding_screen.dart';
import 'package:musafer/modules/search_trip/binding/search_binding.dart';
import 'package:musafer/modules/trip_results/binding/trip_results_binding.dart';
import 'package:musafer/modules/trip_results/view/screen/trip_results_screen.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import 'package:musafer/modules/auth/verification/views/screen/verify_email_screen.dart';
import 'package:musafer/modules/search_trip/view/screen/search_screen.dart';
import 'package:musafer/modules/main_layout/binding/main_layout_binding.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoute.onboarding, page: () => OnBoarding(),binding: OnBoardingBinding()),
    GetPage(name: AppRoute.login, page: () => LoginScreen(),binding: LoginBinding()),
    GetPage(name: AppRoute.verifyEmail, page: () =>  VerifyEmailScreen(), binding: VerificationBinding()),
    GetPage(name: AppRoute.resetPassword, page: () =>  ResetPasswordScreen(), binding: ForgetPasswordBinding()),
    GetPage(name: AppRoute.main_layout, page: () =>  MainLayoutScreen(), binding: MainLayoutBinding(),),
    GetPage(name: AppRoute.home, page: () =>  TripSearchScreen(), ),
    GetPage(name: AppRoute.trip_results, page: () =>  TripResultsScreen(), binding: TripResultsBinding(),),
    // GetPage(name: AppRoute.search_trip, page: () =>  TripSearchScreen(), binding: TripSearchBinding(),),

  ];
}
