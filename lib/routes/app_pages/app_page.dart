
import 'package:get/get.dart';

import 'package:musafer/modules/auth/login/bindings/login_binding.dart';
import 'package:musafer/modules/auth/login/views/screen/login_screen.dart';
import 'package:musafer/modules/auth/sign_up/binding/signup_binding.dart';
import 'package:musafer/modules/auth/verification/bindings/verification_binding.dart';
import 'package:musafer/modules/main_layout/view/screen/main_layout_screen.dart';
import 'package:musafer/modules/on_boarding/bindings/onboarding_binding.dart';
import 'package:musafer/modules/on_boarding/views/screen/onboarding_screen.dart';
import 'package:musafer/modules/profile/view/screen/profile_view.dart';
import 'package:musafer/modules/search_trip/binding/search_binding.dart';
import 'package:musafer/modules/trip_details/view/screen/trip_details_screen.dart';
import 'package:musafer/modules/trip_results/binding/trip_results_binding.dart';
import 'package:musafer/modules/trip_results/view/screen/trip_results_screen.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import 'package:musafer/modules/auth/verification/views/screen/verify_email_screen.dart';
import 'package:musafer/modules/search_trip/view/screen/search_screen.dart';
import 'package:musafer/modules/main_layout/binding/main_layout_binding.dart';
import '../../modules/booking_history/binding/booking_history_binding.dart';
import '../../modules/booking_history/view/screen/booking_history_screen.dart';
import '../../modules/profile/binding/profile_binding.dart';
import '../../modules/profile/view/screen/personal_info_screen.dart';
import '../../modules/send_complaints/bindings/complaints_binding.dart';
import '../../modules/send_complaints/views/screen/complaints_view.dart';
import '../../modules/settings/view/screen/settings_view.dart';
import '../../modules/trip_details/binding/trip_details_binding.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoute.onboarding, page: () => OnBoarding(),binding: OnBoardingBinding()),
    GetPage(name: AppRoute.login, page: () => LoginScreen(),binding: LoginBinding()),
    GetPage(name: AppRoute.verifyEmail, page: () =>  VerifyEmailScreen(), binding: VerificationBinding()),
    GetPage(name: AppRoute.main_layout, page: () =>  MainLayoutScreen(), binding: MainLayoutBinding(),),
    GetPage(name: AppRoute.home, page: () =>  TripSearchScreen(), ),
    GetPage(name: AppRoute.trip_results, page: () =>  TripResultsScreen(), binding: TripResultsBinding(),),
    GetPage(name: AppRoute.complaints, page: () =>  ComplaintsView(), binding: ComplaintsBinding(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.settings, page: () =>  SettingsView(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.profile, page: () =>  ProfileView(), binding: ProfileBinding(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.trip_details, page: () =>  TripDetailsScreen(), binding: TripDetailsBinding(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.booking_history, page: () => BookingHistoryScreen(), binding: BookingHistoryBinding(), ),
    GetPage(name: AppRoute.personal_info, page: () =>  PersonalInfoScreen(),),
  ];
}
