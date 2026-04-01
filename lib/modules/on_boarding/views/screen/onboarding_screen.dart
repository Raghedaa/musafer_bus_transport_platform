import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import 'package:musafer/modules/on_boarding/controllers/customdotscontroller.dart';
import 'package:musafer/modules/on_boarding/controllers/on_boarding_controller.dart';
import 'package:musafer/modules/on_boarding/views/widget/CustomHeaderOnBoarding.dart';
import 'package:musafer/modules/on_boarding/views/widget/customslider.dart';

class OnBoarding extends GetView<OnBoardingControllerImp> {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  const Expanded(flex: 4, child: CustomSliderOnBoarding()),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const CustomDotControllerOnBoarding(),
                        const Spacer(),
                        CustomButton(
                          text: "Next",
                          onPressed: controller.next,
                          width: 220.w,
                          height: 55.h,
                          color: AppColor.darkgreen,
                          borderRadius: 25.r,
                          textColor: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const CustomHeaderOnBoarding(),
          ],
        ),
      ),
    );
  }
}