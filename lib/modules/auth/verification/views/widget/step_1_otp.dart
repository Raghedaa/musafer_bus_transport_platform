import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            Text("Verify Phone",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        
            SizedBox(height: 10.h),
        
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "We've sent a 4-digit code to your phone number",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  TextSpan(
                    text: " +963 *** *** 42",
                    style: TextStyle(
                      color: AppColor.darkgreen,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        
        
            SizedBox(height: 30.h),
        
            VerificationCodeField(
              onCompleted: controller.onOtpCompleted,
            ),
        
            SizedBox(height: 20.h),
        
            Center(
              child:
              Column(
                children: [
                  Text(
                    "Didn't receive the code?",
                    style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.darkgreen),
                  ),
                  Text(
                    "Resend (45s)",
                    style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.darkgreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}