import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/data/providers/static/onBoardingList.dart';
import 'package:musafer/modules/on_boarding/controllers/on_boarding_controller.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      itemCount: onBoardingList.length,
      itemBuilder: (context, i) {
        final model = onBoardingList[i];

        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: model.rotation ?? 0.0,
                child: Container(
                  width: (model.width ?? 300).w,
                  height: (model.height ?? 300).h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: model.borderColor ?? Colors.transparent,
                      width: model.borderWidth ?? 0,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.asset(
                      model.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              Text(
                model.title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                  color: AppColor.darkgreen,
                ),
              ),

              SizedBox(height: 15.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  model.body!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.6,
                    color: AppColor.darkgreen,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}