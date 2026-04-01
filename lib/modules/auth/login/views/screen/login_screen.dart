import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/modules/auth/login/controllers/login_controller.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import '../widget/auth_header.dart';
import '../widget/auth_toggle.dart';
import '../widget/social_login.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              const Center(child: AuthHeader()), // جعل الهيدر في المنتصف
              SizedBox(height: 30.h),
              const AuthToggle(),
              SizedBox(height: 30.h),

              Text(
                "PHONE NUMBER OR EMAIL",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.grey,
                ),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                hint: "e.g. +1 234 567 890",
                prefixIcon: Icons.person_outline,
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PASSWORD",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.resetPassword);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppColor.darkgreen,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Obx(
                () => CustomTextFormField(
                  hint: "********",
                  controller: controller.passwordController,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: controller.isPasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  obscureText: controller.isPasswordHidden.value,
                  onSuffixPressed: () =>
                      controller.togglePasswordVisibility(), // ✅ ربط الأكشن
                  // validator: (val) => controller.validatePassword(val!), // سنضيفها لاحقاً
                ),
              ),

              Obx(
                () => Row(
                  children: [
                    SizedBox(
                      height: 24.w,
                      width: 24.w,
                      child: Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (val) {
                          controller.toggleRememberMe(
                            val,
                          );
                        },
                        activeColor: AppColor.darkgreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => controller.toggleRememberMe(
                        !controller.rememberMe.value,
                      ),
                      child: Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColor.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // زر تسجيل الدخول
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoute.main_layout);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkgreen,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(fontSize: 16.sp, color: AppColor.white),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 18.sp,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              const SocialLogin(),

              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New traveler? ",
                    style: TextStyle(color: AppColor.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoute.verifyEmail);
                    },
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
