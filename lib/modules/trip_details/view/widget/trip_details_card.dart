import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/data/models/trip_result_model.dart';

class TripDetailsCard extends StatelessWidget {
  final TripResultModel trip;
  const TripDetailsCard({super.key, required this.trip});

  String formatTime(String time) {
    if (Get.locale?.languageCode == 'ar') {
      return time
          .replaceAll("AM", "صباحاً")
          .replaceAll("PM", "مساءً");
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColor.black, size: 20.sp),
                onPressed: () => Get.back(),
              ),
              Text(
                "Trip Details".tr,
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              IconButton(
                onPressed: () {
                  // أضف وظيفة المشاركة هنا
                },
                icon: Icon(Icons.share_outlined, color: AppColor.black, size: 22.sp),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.companyName, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColor.amber, size: 16.sp),
                          Text(" ${trip.rating} ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("(${trip.reviewsCount / 1000}k ${"reviews".tr})", style: TextStyle(color: AppColor.grey, fontSize: 12.sp)),
                        ],
                      ),
                    ],
                  ),
                  _buildTag("EXECUTIVE".tr),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStationInfo(formatTime(trip.departureTime), trip.departureTerminal.tr),
                  Icon(Icons.directions_bus, color: AppColor.darkgreen, size: 30.sp),
                  _buildStationInfo(formatTime(trip.arrivalTime), trip.arrivalTerminal.tr, isEnd: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStationInfo(String time, String terminal, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(time, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        Text(terminal, style: TextStyle(color: AppColor.grey, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: AppColor.darkgreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
      child: Text(label, style: TextStyle(color: AppColor.darkgreen, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }
}