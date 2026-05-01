import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/utils/validators/auth_validator.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_text_form_field.dart';
import '../../controllers/login_controller.dart';

class LoginFormFields extends GetView<LoginController> {
  const LoginFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PHONE NUMBER ".tr,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColor.primaryGrey),
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            hint: "09** *** ***".tr,
            controller: controller.phoneController,

            keyboardType: TextInputType.number,

            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android, color: AppColor.primaryGrey, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "+963".tr,
                    style: TextStyle(
                      color: AppColor.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    height: 20.h,
                    width: 1,
                    color: AppColor.primaryGrey.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            validator: AuthValidator.phone,
          ),
        ],
      ),
    );
  }
}