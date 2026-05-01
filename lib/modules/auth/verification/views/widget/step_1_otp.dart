import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/verification_code_field.dart';
import 'package:musafer/modules/auth/verification/controllers/verification_controller.dart';

class Step1Otp extends GetView<VerificationController> {
  const Step1Otp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:20 ,),
            Text("Verify Phone".tr,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold,color: AppColor.black)),
        
            SizedBox(height: 10.h),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "We've sent a 6-digit code to your phone number".tr,
                    style: TextStyle(color: AppColor.primaryGrey, fontSize: 14.sp),
                  ),

                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        controller.maskedPhone,
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
        
            SizedBox(height: 30.h),

            Directionality(
              textDirection: TextDirection.ltr,
              child: VerificationCodeField(
                onCompleted: controller.onOtpCompleted,
                onChanged: (value) => controller.otpLength.value = value.length,
              ),
            ),

            SizedBox(height: 20.h),
            Obx(() => GestureDetector(
              onTap: controller.canResend.value
                  ? () => controller.resendCode()
                  : null,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't receive the code?".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      controller.canResend.value
                          ? "Resend".tr
                          : "${"Resend".tr} (${controller.secondsRemaining.value}s)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.canResend.value ? AppColor.darkgreen : AppColor.grey.withOpacity(0.6),
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )),

          ],
        ),
      ),
    );
  }
}