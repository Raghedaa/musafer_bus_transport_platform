import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/auth/verification/controllers/verification_controller.dart';
import 'package:musafer/modules/auth/verification/views/widget/custom_step_indicator.dart';
import 'package:musafer/modules/auth/verification/views/widget/step_1_otp.dart';
import 'package:musafer/modules/auth/verification/views/widget/step_2_otp.dart';


class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 20.w),
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.black),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Column(
          children: [
            Text("Verification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColor.black)),
            SizedBox(height: 20.h),

            Obx(() => CustomStepIndicator(
              currentStep: controller.currentStep.value,
            )),

            SizedBox(height: 40.h),

            Expanded(
              child: Obx(() {
                if (controller.currentStep.value == 0) {
                  return const Step1Otp();
                } else {
                  return const Step2Profile();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}