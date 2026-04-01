import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/booking_summary_controller.dart';

class TripDetailsSection extends GetView<BookingSummaryController> {
  const TripDetailsSection({super.key});

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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRIP DETAILS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppColor.grey,
            ),
          ),
          SizedBox(height: 10.h),
          Card(
            elevation: 0,
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
                            trip.departureTime,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            trip.departureTerminal,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.grey,
                            ),
                          ),
                        ],
                      ),

                      Icon(
                        Icons.directions_bus,
                        color: AppColor.darkgreen,
                        size: 30.sp,
                      ),

                      Column(
                        children: [
                          Text(
                            trip.arrivalTime,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            trip.arrivalTerminal,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.grey,
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
                      // التاريخ
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                              color: AppColor.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            trip.departureTime, // يفضل هنا استخدام تاريخ الرحلة الفعلي إذا توفر
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),

                      // المقاعد المختارة
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seats",
                            style: TextStyle(
                              color: AppColor.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            booking.selectedSeats.join(", "),
                            style: TextStyle(
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