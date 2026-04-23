import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/on_boarding/controllers/on_boarding_controller.dart';

class CustomHeaderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomHeaderOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingControllerImp>(
      builder: (controller) => Positioned(
        top: 0.h,
        left: 10.w,
        right: 10.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.currentPage > 0
                ? IconButton(
              onPressed: controller.back,
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor.darkgreen,
              ),
            )
                : const SizedBox.shrink(),

            TextButton(
              onPressed: () => controller.skip(),
              child: Text(
                "Skip".tr,
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}