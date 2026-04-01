import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/constants/app_image.dart';
import 'package:musafer/core/shared/custom_button.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/core/shared/verification_code_field.dart';
import '../../controllers/forget_password_controller.dart';

class ResetPasswordScreen extends GetView<ForgetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(color: AppColor.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  AppImageAsset.forget_password,
                  width: double.infinity,
                  height: 250.h,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: AppColor.darkgreen, height: 350.h),
                ),

                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Transform.translate(
              offset: Offset(0, -50.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "***",
                      style: TextStyle(
                        fontSize: 45.sp,
                        color: AppColor.darkgreen,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),

                    Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkgreen,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Text("Enter the 6-digit code sent to your email"),
                    SizedBox(height: 30.h),
                    const VerificationCodeField(),
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      hint: "New Password",
                      controller: controller.passwordController,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextFormField(
                      hint: "Confirm Password",
                      controller: controller.confirmPasswordController,
                      prefixIcon: Icons.lock_reset,
                      obscureText: true,
                    ),
                    SizedBox(height: 30.h),
                    CustomButton(
                      text: "Reset Password",
                      color: AppColor.darkgreen,
                      onPressed: () => controller.resetPassword(),
                    ),
                    SizedBox(height: 15.h),
                    TextButton(
                      onPressed: () {
                        /* Logic */
                      },
                      child: Text(
                        "Resend Code",
                        style: TextStyle(
                          color: AppColor.darkgreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
