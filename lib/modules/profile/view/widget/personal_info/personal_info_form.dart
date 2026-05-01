import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../../../../core/shared/custom_text_form_field.dart';
import '../../../../../core/utils/validators/auth_validator.dart';
import '../../../controller/personal_info_controller.dart';

class PersonalInfoForm extends GetView<PersonalInfoController> {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("FULL NAME".tr),
        CustomTextFormField(
          controller: controller.nameController,
          hint: "name".tr,
          prefixIcon: const Icon(Icons.person_outline),
          validator: AuthValidator.fullName,
        ),
        SizedBox(height: 20.h),

        _buildLabel("PHONE NUMBER ".tr),
        CustomTextFormField(
          hint: "09** *** ***".tr,
          controller: controller.phoneController,
          keyboardType: TextInputType.number,
          // textAlign: TextAlign.left,
          prefixIcon: _buildPhonePrefix(),
          validator: AuthValidator.phone,
        ),
        SizedBox(height: 20.h),

        _buildLabel("Address".tr),
        CustomTextFormField(
          controller: controller.addressController,
          hint: "Address".tr,
          prefixIcon: const Icon(Icons.location_on_outlined),
          validator: (val) => val!.isEmpty ? "Required".tr : null,
        ),
        SizedBox(height: 20.h),

        _buildLabel("Email".tr),
        CustomTextFormField(
          controller: controller.emailController,
          hint: "Email".tr,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: (val) => !GetUtils.isEmail(val!) ? "Invalid Email".tr : null,
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryGrey,
        ),
      ),
    );
  }

  Widget _buildPhonePrefix() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_android, color: AppColor.primaryGrey, size: 20.sp),
            SizedBox(width: 8.w),
            Text("+963".tr, style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold, fontSize: 14.sp)),
            SizedBox(width: 8.w),
            Container(height: 20.h, width: 1, color: AppColor.primaryGrey.withOpacity(0.5)),
          ],
        ),
    );
  }
}