// lib/modules/complaints/views/widgets/complaints_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';

class ComplaintsHeader extends StatelessWidget {
  const ComplaintsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How can we help?".tr,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.black
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Please write your complaint details for review.".tr,
          style: TextStyle(fontSize: 14.sp, color: AppColor.grey),
        ),
      ],
    );
  }
}