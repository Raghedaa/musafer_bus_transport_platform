import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_text_form_field.dart';
import '../../../../../routes/app_routes/app_routes.dart';
import '../../controllers/login_controller.dart';

class LoginFormFields extends GetView<LoginController> {
  const LoginFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PHONE NUMBER OR EMAIL".tr,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColor.primaryGrey),
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          hint: "e.g. +963 72** *** 890".tr,
          controller: controller.usernameController,
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PASSWORD".tr,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColor.primaryGrey),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.forget_password),
              child: Text(
                "Forgot Password?".tr,
                style: TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.w600),
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
            onSuffixPressed: () => controller.togglePasswordVisibility(),
          ),
        ),
      ],
    );
  }
}