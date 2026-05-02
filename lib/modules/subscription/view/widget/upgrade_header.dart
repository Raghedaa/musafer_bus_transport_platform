import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'section_label.dart';

class UpgradeHeader extends StatelessWidget {
  const UpgradeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         SectionLabel(label: "UPGRADE PACKAGES".tr),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColor.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Obx(() =>Text(
            "20% OFF INCLUDED".tr,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color:  AppColor.black,
            ),
          ),
        )
        )
      ],
    );
  }
}