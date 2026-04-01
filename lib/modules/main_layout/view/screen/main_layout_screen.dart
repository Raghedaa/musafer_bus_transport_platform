import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/booking_summary/binding/booking_summary_binding.dart';
import 'package:musafer/modules/booking_summary/view/screen/booking_summary_screen.dart';
import 'package:musafer/modules/select_seat/binding/select_seat_binding.dart';
import 'package:musafer/modules/select_seat/view/screen/select_seat_screen.dart';
import 'package:musafer/modules/subscription/view/screen/subscription_screen.dart';
import 'package:musafer/modules/ticket_details/view/screen/ticket_details_screen.dart';
// استيراد الـ Bindings والـ Screens
import '../../../booking_history/view/screen/booking_history_screen.dart';
import '../../../search_trip/view/screen/search_screen.dart';
import '../../../search_trip/binding/search_binding.dart';
import '../../../subscription/controllers/subscription_controller.dart';
import '../../../ticket_details/binding/ticket_details_binding.dart';
import '../../../trip_results/view/screen/trip_results_screen.dart';
import '../../../trip_results/binding/trip_results_binding.dart';
import '../../controller/main_layout_controller.dart';

class MainLayoutScreen extends GetView<MainLayoutController> {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: [

            Navigator(
              key: Get.nestedKey(1),
              initialRoute: '/search',
              onGenerateRoute: (settings) {
                if (settings.name == '/search') {
                  return GetPageRoute(
                    page: () => const TripSearchScreen(),
                    binding: TripSearchBinding(),
                  );
                } else if (settings.name == '/results') {
                  return GetPageRoute(
                    page: () => const TripResultsScreen(),
                    binding: TripResultsBinding(),
                  );
                }
                else if (settings.name == '/select_seat') {
                  return GetPageRoute(
                    page: () => const SelectSeatScreen(),
                    binding: SelectSeatBinding(),
                  );
                }
                else if (settings.name == '/booking_summary') {
                  return GetPageRoute(
                    page: () => const BookingSummaryScreen(),
                    binding: BookingSummaryBinding(),
                  );
                }
                else if (settings.name == '/ticket_details') {
                  return GetPageRoute(
                    page: () => const TicketDetailsScreen(),
                    binding: TicketDetailsBinding(),
                  );
                }
                return null;
              },
            ),
            const BookingHistoryScreen(),
            // const Center(child: Text("Bookings")),

            GetBuilder<SubscriptionController>(
              init: SubscriptionController(),
              builder: (controller) => const SubscriptionScreen(),
            ),
            // const Center(child: Text("Offers")),

            const Center(child: Text("Settings")),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        selectedItemColor: AppColor.darkgreen,
        unselectedItemColor: AppColor.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildBottomNavItem(
            icon: Icons.search,
            label: "Explore",
            index: 0,
          ),
          _buildBottomNavItem(
            icon: Icons.confirmation_num_outlined,
            label: "Bookings",
            index: 1,
          ),
          _buildBottomNavItem(
            icon: Icons.local_offer_outlined,
            label: "Offers",
            index: 2,
          ),
          _buildBottomNavItem(
            icon: Icons.settings_outlined,
            label: "Settings",
            index: 3,
          ),
        ],
      )),
    );
  }



  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index
  }) {
    bool isSelected = controller.currentIndex.value == index;

    return BottomNavigationBarItem(
      label: label,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: isSelected ? 4.h : 0),
        child: Icon(
          icon,
          // تكبير الأيقونة عند الاختيار (مثلاً من 24 إلى 30)
          size: isSelected ? 30.sp : 24.sp,
        ),
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30.sp, color: AppColor.darkgreen),
          SizedBox(height: 4.h), // مسافة بين الأيقونة والخط
          Container(
            width: 15.w, // عرض الخط الصغير
            height: 2.h, // سماكة الخط
            decoration: BoxDecoration(
              color: AppColor.darkgreen,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}