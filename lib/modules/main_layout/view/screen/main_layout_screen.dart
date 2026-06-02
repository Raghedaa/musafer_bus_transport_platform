import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/settings/view/screen/settings_view.dart';
import '../../../booking_history/view/screen/booking_history_screen.dart';
import '../../../profile/view/screen/profile_view.dart';
import '../../../subscription/view/screen/subscription_screen.dart';
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
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Obx(() {
          return IndexedStack(
            key: ValueKey(controller.currentIndex.value),
            index: controller.currentIndex.value,
            children: [
              Obx(() {
                final stack = controller.bookingStack;
                return Stack(
                  children: stack.asMap().entries.map((entry) {
                    final index = entry.key;
                    final page = entry.value;
                    return Offstage(
                      offstage: index != stack.length - 1,
                      child: page,
                    );
                  }).toList(),
                );
              }),


              Obx(() {
                final stack = controller.subscriptionStack;
                return Stack(
                  children: [
                    const SubscriptionScreen(),
                    ...stack.map((page) => page).toList(),
                  ],
                );
              }),
              Obx(() {
                final stack = controller.exploreStack;
                return Stack(
                  children: stack.asMap().entries.map((entry) {
                    final index = entry.key;
                    final page = entry.value;
                    return Offstage(
                      offstage: index != stack.length - 1,
                      child: page,
                    );
                  }).toList(),
                );
              }),

              Obx(() {
                final stack = controller.notificationStack;
                return Stack(
                  children: stack.asMap().entries.map((entry) {
                    final index = entry.key;
                    final page = entry.value;
                    return Offstage(
                      offstage: index != stack.length - 1,
                      child: page,
                    );
                  }).toList(),
                );
              }),
              Obx(() {
                final stack = controller.profileStack;
                return Stack(
                  children: stack.asMap().entries.map((entry) {
                    final index = entry.key;
                    final page = entry.value;
                    return Offstage(
                      offstage: index != stack.length - 1,
                      child: page,
                    );
                  }).toList(),
                );
              }),            ],
          );
        }),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(() => Container(
          margin: EdgeInsets.only(top: 38.h),
          height: 60.r,
          width: 60.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: AppColor.white,
            shape: const CircleBorder(
              side: BorderSide(color: Colors.black12, width: 1),
            ),
            onPressed: () => controller.changePage(2),
            child: Icon(Icons.home, color: AppColor.darkgreen, size: 28.r),
          ),
        )),

        bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          selectedItemColor: AppColor.darkgreen,
          unselectedItemColor: AppColor.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num_outlined,
                  size: controller.currentIndex.value == 0 ? 28 : 22),
              label: "Bookings".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined,
                  size: controller.currentIndex.value == 1 ? 28 : 22),
              label: "Offers".tr,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.transparent),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined,
                  size: controller.currentIndex.value == 3 ? 28 : 22),
              label: "Settings".tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline,
                  size: controller.currentIndex.value == 4 ? 28 : 22),
              label: "Profile".tr,
            ),
          ],
        )),
      ),
    );
  }
}