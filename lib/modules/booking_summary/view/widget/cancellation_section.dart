import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

class CancellationSection extends StatelessWidget {
  const CancellationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gavel, color: AppColor.orange, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cancellation Terms".tr,
                  style: TextStyle(
                    color: HSLColor.fromColor(AppColor.orange)
                        .withLightness(
                      (HSLColor.fromColor(AppColor.orange).lightness - 0.1)
                          .clamp(0.0, 1.0),
                    )
                        .toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Full refund if cancelled 24h before departure. 50% refund if cancelled 12h before.".tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColor.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}