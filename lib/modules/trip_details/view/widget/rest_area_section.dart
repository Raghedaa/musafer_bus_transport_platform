import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../../../../data/models/rest_area_model.dart';


class RestAreaSection extends StatelessWidget {
  final List<RestAreaModel> restAreas;

  const RestAreaSection({super.key, required this.restAreas});

  @override
  Widget build(BuildContext context) {
    if (restAreas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Rest Areas".tr,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),

        ...restAreas.map((area) => Container(
          margin: EdgeInsets.only(bottom: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.coffee,
                  color: AppColor.primary, size: 18.sp),
              SizedBox(width: 8.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(area.name,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600)),

                    Row(
                      children: [
                        Icon(Icons.star,
                            color: AppColor.amber, size: 12.sp),
                        Text(" ${area.rating} ",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColor.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "${area.durationMinutes ?? 0} ${"min".tr}",
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}