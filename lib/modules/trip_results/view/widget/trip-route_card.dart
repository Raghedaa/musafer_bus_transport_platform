import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../../../search_trip/controllers/search_controller.dart';

class TripRouteCard extends StatelessWidget {
  const TripRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<TripSearchController>();

    return Obx(() {
      return Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              _buildLoc("FROM".tr, searchController.origin.value.tr,
                  CrossAxisAlignment.start), Expanded(
                child: Column(
                  children: [
                    Icon(Icons.directions_bus, color: AppColor.darkgreen,
                        size: 20.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Divider(color: AppColor.grey.withOpacity(0.2),
                          thickness: 1),
                    ),
                  ],
                ),
              ),
              _buildLoc("TO".tr, searchController.destination.value.tr,
                  CrossAxisAlignment.end),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoc(String label, String city, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: TextStyle(color: AppColor.grey, fontSize: 10.sp)),
        Text(city, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp,color: AppColor.black)),
      ],
    );
  }
}