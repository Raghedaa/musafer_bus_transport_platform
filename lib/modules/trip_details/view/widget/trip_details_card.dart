import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../../data/models/trip_model.dart';
import '../../../main_layout/controller/main_layout_controller.dart';

class TripDetailsCard extends StatelessWidget {
  final TripModel trip;
  const TripDetailsCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
          child: SizedBox(
            height: 30.h,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: isArabic ? null : 0,
                  right: isArabic ? 0 : null,
                  child: IconButton(
                    onPressed: () {
                      bool popped = Get.find<MainLayoutController>().popExplore();
                   if (!popped) {
                        Get.find<MainLayoutController>().changePage(2);
                      }
                    },
                    icon: Icon(
                      Icons.adaptive.arrow_back_rounded,
                      size: 20.sp,
                      color: AppColor.black,
                    ),
                  ),
                ),
                Text(
                  "Trip Details".tr,
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColor.grey.withOpacity(0.2),
                        child: Icon(
                          Icons.directions_bus,
                          color: AppColor.primary,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trip.companyName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(Icons.star, color: AppColor.amber, size: 14.sp),
                              Text(
                                " ${trip.rating.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildStatusRouteTag(trip.isDirect),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14.sp, color: AppColor.grey),
                      SizedBox(width: 6.w),
                      Text(trip.tripDate, style: TextStyle(color: AppColor.grey, fontSize: 13.sp, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Price".tr, style: TextStyle(color: AppColor.grey, fontSize: 11.sp, fontWeight: FontWeight.w500)),
                      SizedBox(height: 2.h),
                      Text(
                        "${trip.price.toInt()} ${"SP".tr}",
                        style: TextStyle(color: AppColor.primary, fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRouteTag(bool isDirect) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isDirect ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        isDirect ? "Direct".tr : "Non-Direct".tr,
        style: TextStyle(color: isDirect ? Colors.green : Colors.orange, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}