import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../trip_results/controllers/trip_results_controller.dart';
import '../../controllers/booking_summary_controller.dart';

class TripDetailsSection extends GetView<BookingSummaryController> {
  const TripDetailsSection({super.key});

  String formatTime(String time) {
    if (Get.locale?.languageCode == 'ar') {
      return time
          .toUpperCase()
          .replaceAll("AM", "صباحاً")
          .replaceAll("PM", "مساءً");
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final booking = controller.bookingSummaryModel.value;

      if (booking == null) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      final trip = booking.tripDetails;
      final trip_result_controller = Get.find<TripResultsController>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRIP DETAILS".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppColor.black,
            ),
          ),
          SizedBox(height: 10.h),
          Card(
            elevation: 0,
            color: AppColor.grey.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            formatTime(trip.departureTime),
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            trip.departureTerminal,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 12.sp,
                              color: AppColor.grey,
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColor.grey.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Icon(
                              Icons.directions_bus,
                              size: 16.sp,
                              color: AppColor.darkgreen,
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColor.grey.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Icon(
                              Icons.circle,
                              size: 12.sp,
                              color: AppColor.grey,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            formatTime(trip.arrivalTime),
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            formatTime(trip.arrivalTime),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Divider(height: 30.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date".tr,
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            trip_result_controller.travelDate.value,
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),

                      //  المختارة
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seats".tr,
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            booking.selectedSeats.join(", "),
                            style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
