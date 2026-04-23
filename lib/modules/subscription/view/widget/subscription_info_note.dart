import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

class SubscriptionInfoNote extends StatelessWidget {
  const SubscriptionInfoNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColor.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColor.orange, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
                "subscription_note".tr,
                style: TextStyle(color: AppColor.orange, fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}