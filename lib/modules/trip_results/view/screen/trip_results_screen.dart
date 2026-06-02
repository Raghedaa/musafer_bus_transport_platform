import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/shared/trip_card/trip_card_main.dart';
import '../../controllers/trip_results_controller.dart';
import '../widget/trip_info_header.dart';
import '../widget/trip-route_card.dart';
import '../widget/filter_chips_row.dart';
import '../../../../core/constants/app_color.dart';

class TripResultsScreen extends GetView<TripResultsController> {
  const TripResultsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripResultsController>();
    return Scaffold(
      backgroundColor: AppColor.white.withOpacity(0.98),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15.h),
            const TripInfoHeader(),
            const TripRouteCard(),
            SizedBox(height: 12.h),
            const FilterChipsRow(),
            SizedBox(height: 10.h),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                  );
                }

                if (controller.trips.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bus_alert_rounded, size: 48.sp, color: AppColor.grey.withOpacity(0.5)),
                          SizedBox(height: 12.h),
                          Text(
                            "No trips found matching your search criteria.".tr,
                            style: TextStyle(fontSize: 14.sp, color: AppColor.grey, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                print("=== الرحلات التي ستعرض في UI ===");
                for (var trip in controller.trips) {
                  print("UI Trip ID: ${trip.id}, من: ${trip.originCity} إلى: ${trip.destinationCity}");
                }

                return ListView.builder(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.trips.length,
                  itemBuilder: (context, index) {
                    final trip = controller.trips[index];
                    print("محاولة بناء البطاقة للرحلة رقم: ${trip.id}");

                    try {
                      print("قبل بناء TripCardMain للرحلة ${trip.id}");
                      final card = TripCardMain(tripmodel: trip);
                      print("بعد بناء TripCardMain للرحلة ${trip.id} - نوع الكائن: ${card.runtimeType}");
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: card,
                      );
                    } catch (e, stackTrace) {
                      print("خطأ في بناء TripCardMain للرحلة ${trip.id}: $e");
                      print("Stack trace: $stackTrace");
                      // عرض بطاقة بديلة بسيطة توضح وجود خطأ
                      return Card(
                        color: Colors.red[50],
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: ListTile(
                          title: Text("⚠️ خطأ في عرض الرحلة ${trip.id}"),
                          subtitle: Text("${trip.originCity} → ${trip.destinationCity}\nالسعر: ${trip.price} ليرة"),
                        ),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}