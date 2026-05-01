import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/core/utils/validators/auth_validator.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../controllers/signup_controller.dart';


class SignUpFormCard extends GetView<SignUpController> {
  const SignUpFormCard({super.key});

  @override
  Widget build(BuildContext context) {

    return  Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FULL NAME".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.grey,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: controller.fullNameController,
              hint: "name".tr,
              prefixIcon: Icon(Icons.person_outline,),
              validator: AuthValidator.fullName,
            ),
            SizedBox(height: 20.h),
            Text(
              "PHONE NUMBER".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.grey,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              hint: "09** *** ***".tr,
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

            SizedBox(height: 20.h),

            Text(
              "GENDER".tr,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColor.grey),
            ),
            SizedBox(height: 8.h),
            Obx(() => Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Male".tr, style: TextStyle(fontSize: 14.sp)),
                    value: "male",
                    groupValue: controller.selectedGender.value,
                    onChanged: (val) => controller.updateGender(val),
                    activeColor: AppColor.darkgreen,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Female".tr, style: TextStyle(fontSize: 14.sp)),
                    value: "female",
                    groupValue: controller.selectedGender.value,
                    onChanged: (val) => controller.updateGender(val),
                    activeColor: AppColor.darkgreen,
                  ),
                ),
              ],
            )),
          ],
        ),
    );
  }
}