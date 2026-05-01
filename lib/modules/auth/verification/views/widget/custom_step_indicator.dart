import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

class CustomStepIndicator extends StatelessWidget {
  final int currentLength;

  const CustomStepIndicator({super.key, required this.currentLength});

  @override
  Widget build(BuildContext context) {
    double progress = currentLength / 6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(
            label: "send".tr,
            icon: Icons.send_rounded,
            isCompleted: true,
          ),

          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  height: 4.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColor.primaryGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: (MediaQuery.of(context).size.width * 0.55) * progress,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColor.darkgreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          _buildStep(
            label: "verify".tr,
            icon: Icons.verified_user_rounded,
            isCompleted: currentLength == 6,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String label,
    required IconData icon,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 50.r,
          height: 50.r,
          decoration: BoxDecoration(
            color: isCompleted ? AppColor.primary : AppColor.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? AppColor.primary : AppColor.primaryGrey.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: isCompleted
                ? [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ]
                : [],
          ),
          child: Center(
            child: Icon(
              icon,
              color: isCompleted ? AppColor.white : AppColor.grey,
              size: 22.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? AppColor.primary : AppColor.primaryGrey,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}