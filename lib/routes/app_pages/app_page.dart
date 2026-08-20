
import 'package:get/get.dart';

import 'package:musafer/modules/auth/login/bindings/login_binding.dart';
import 'package:musafer/modules/auth/login/views/screen/login_screen.dart';
import 'package:musafer/modules/auth/sign_up/binding/signup_binding.dart';
import 'package:musafer/modules/auth/verification/bindings/verification_binding.dart';
import 'package:musafer/modules/main_layout/view/screen/main_layout_screen.dart';
import 'package:musafer/modules/notification/binding/notification_binding.dart';
import 'package:musafer/modules/notification/view/screen/notification_screen.dart';
import 'package:musafer/modules/on_boarding/bindings/onboarding_binding.dart';
import 'package:musafer/modules/on_boarding/views/screen/onboarding_screen.dart';
import 'package:musafer/modules/profile/view/screen/profile_view.dart';
import 'package:musafer/modules/search_trip/binding/search_binding.dart';
import 'package:musafer/modules/subscription_details/binding/subscription_details_binding.dart';
import 'package:musafer/modules/trip_details/view/screen/trip_details_screen.dart';
import 'package:musafer/modules/trip_results/binding/trip_results_binding.dart';
import 'package:musafer/modules/trip_results/view/screen/trip_results_screen.dart';
import 'package:musafer/modules/trip_tracking/binding/trip_tracking_binding.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import 'package:musafer/modules/auth/verification/views/screen/verify_email_screen.dart';
import 'package:musafer/modules/search_trip/view/screen/search_screen.dart';
import 'package:musafer/modules/main_layout/binding/main_layout_binding.dart';
import '../../modules/booking_history/binding/booking_history_binding.dart';
import '../../modules/booking_history/view/screen/booking_history_screen.dart';
import '../../modules/profile/binding/profile_binding.dart';
import '../../modules/profile/view/screen/personal_info_screen.dart';
import '../../modules/complaints/bindings/complaints_binding.dart';
import '../../modules/complaints/controllers/complaints_controller.dart';
import '../../modules/complaints/controllers/my_complaints_controller.dart';
import '../../modules/complaints/views/screen/send_complaints_screen.dart';
import '../../modules/complaints/views/screen/my_complaints_screen.dart';
import '../../modules/settings/view/screen/settings_view.dart';
import '../../modules/subscription_details/view/screen/subscription_details_screen.dart';
import '../../modules/trip_details/binding/trip_details_binding.dart';
import '../../modules/trip_tracking/view/screen/trip_tracking_screen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoute.onboarding, page: () => OnBoarding(),binding: OnBoardingBinding()),
    GetPage(name: AppRoute.login, page: () => LoginScreen(),binding: LoginBinding()),
    GetPage(name: AppRoute.verifyEmail, page: () =>  VerifyEmailScreen(), binding: VerificationBinding()),
    GetPage(name: AppRoute.main_layout, page: () =>  MainLayoutScreen(), binding: MainLayoutBinding(),),
    GetPage(name: AppRoute.home, page: () =>  TripSearchScreen(), ),
    GetPage(name: AppRoute.trip_results, page: () =>  TripResultsScreen(), binding: TripResultsBinding(),),
    GetPage(name: AppRoute.send_complaints, page: () =>  SendComplaintsScreen(),binding: BindingsBuilder(() {Get.lazyPut(() => ComplaintsController());}),),
    GetPage(name: AppRoute.myComplaints, page: () =>  MyComplaintsScreen(), binding: BindingsBuilder(() {Get.lazyPut(() => MyComplaintsController());}),),
    GetPage(name: AppRoute.settings, page: () =>  SettingsView(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.profile, page: () =>  ProfileView(), binding: ProfileBinding(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.trip_details, page: () =>  TripDetailsScreen(), binding: TripDetailsBinding(), transition: Transition.cupertino,),
    GetPage(name: AppRoute.booking_history, page: () => BookingHistoryScreen(), binding: BookingHistoryBinding(), ),
    GetPage(name: AppRoute.personal_info, page: () =>  PersonalInfoScreen(),),
    GetPage(name: AppRoute.subscription_details,page: () => const SubscriptionDetailsScreen(),binding:SubscriptionDetailsBinding()),
    GetPage(name: AppRoute.notification, page: () => NotificationScreen(), binding: NotificationBinding()),
    GetPage(name: AppRoute.TripTrackingScreen, page: () => TripTrackingScreen(), binding: TripTrackingBinding()),
  ];
}
