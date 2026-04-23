import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

class CustomStepIndicator extends StatelessWidget {
  final int currentStep;
  const CustomStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(0, "OTP".tr),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 200.w,
            height: 2.h,
            color: currentStep >= 1 ? AppColor.primary : AppColor.primaryGrey,
          ),
        ),
        _buildStep(1, "Profile".tr),
      ],
    );
  }

  Widget _buildStep(int stepIndex, String label) {
    bool isCompleted = currentStep >= stepIndex;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 45.r,
          height: 45.r,
          decoration: BoxDecoration(
            color: isCompleted ? AppColor.primary : AppColor.primaryGrey,
            shape: BoxShape.circle,
            boxShadow: isCompleted
                ? [
              BoxShadow(color: AppColor.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ]
                : [],
          ),
          child: Center(
            child: Text(
              "${stepIndex + 1}",
              style: TextStyle(
                color: isCompleted ? AppColor.white : AppColor.grey,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? AppColor.primary : AppColor.primaryGrey,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}