import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/settings/view/screen/settings_view.dart';
import 'package:musafer/modules/subscription/controllers/subscription_controller.dart';
import '../../../booking_history/view/screen/booking_history_screen.dart';
import '../../../booking_summary/binding/booking_summary_binding.dart';
import '../../../booking_summary/view/screen/booking_summary_screen.dart';
import '../../../profile/view/screen/profile_view.dart';
import '../../../search_trip/binding/search_binding.dart';
import '../../../search_trip/view/screen/search_screen.dart';
import '../../../select_seat/binding/select_seat_binding.dart';
import '../../../select_seat/view/screen/select_seat_screen.dart';
import '../../../settings/controllers/settings_controller.dart';
import '../../../subscription/view/screen/subscription_screen.dart';
import '../../../ticket_details/binding/ticket_details_binding.dart';
import '../../../ticket_details/view/screen/ticket_details_screen.dart';
import '../../../trip_results/binding/trip_results_binding.dart';
import '../../../trip_results/view/screen/trip_results_screen.dart';
import '../../controller/main_layout_controller.dart';

class MainLayoutScreen extends GetView<MainLayoutController> {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await controller.onWillPop();
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        body:
          Obx(() {
            return IndexedStack(
              index: controller.currentIndex.value,
              children: [

                const BookingHistoryScreen(),
                const SubscriptionScreen(),
                Obx(() => KeyedSubtree(
                  key: ValueKey(controller.exploreStack.length),
                  child: controller.exploreStack.last,
                )),
                const SettingsView(),
                const ProfileView(),
              ],
            );
          }),
        bottomNavigationBar: Obx(() =>BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          selectedItemColor: AppColor.darkgreen,
          unselectedItemColor: AppColor.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.confirmation_num_outlined,
                size: controller.currentIndex.value == 0 ? 28 : 22,
              ),
              label: "Bookings".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_offer_outlined,
                size: controller.currentIndex.value == 1 ? 28 : 22,
              ),
              label: "Offers".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: controller.currentIndex.value == 2 ? 32 : 24, // 👈 أكبر شوي
              ),
              label: "Explore".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                size: controller.currentIndex.value == 3 ? 28 : 22,
              ),
              label: "Settings".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: controller.currentIndex.value == 4 ? 28 : 22,
              ),
              label: "Profile".tr,
            ),
          ],
        )
      ),)
    );
  }
}