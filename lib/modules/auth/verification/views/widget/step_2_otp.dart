import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/modules/auth/verification/controllers/verification_controller.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';

class Step2Profile extends GetView<VerificationController> {
  const Step2Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Complete Profile".tr,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold,color: AppColor.black)),

                SizedBox(height: 20.h),

                CustomTextFormField(
                  hint: "Enter your full name".tr,
                  controller: controller.fullNameController,
                  prefixIcon: Icons.person_outline,
                ),

                SizedBox(height: 20.h),

                Text("GENDER".tr,
                    style: TextStyle(fontSize: 12.sp, color: AppColor.grey)),

                SizedBox(height: 10.h),

                Row(
                  children: [
                    _genderOption(controller, "Male".tr, Icons.male, "male"),
                    SizedBox(width: 20.w),
                    _genderOption(controller, "Female".tr, Icons.female, "female"),
                  ],
                ),

                SizedBox(height: 40.h),

                CustomButton(
                  text: "Verify & Continue".tr,
                  onPressed: (){
                    Get.offAllNamed(AppRoute.main_layout,arguments: 2);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _genderOption(
      VerificationController controller, String title, IconData icon, String value) {
    bool isSelected = controller.selectedGender == value;

    return GestureDetector(
      onTap: () => controller.setGender(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? AppColor.darkgreen : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10.r),
          color: isSelected
              ? AppColor.darkgreen.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? AppColor.darkgreen : AppColor.grey),
            SizedBox(width: 8.w),
            Text(title,
                style: TextStyle(
                    color:
                    isSelected ? AppColor.darkgreen : AppColor.grey)),
          ],
        ),
      ),
    );
  }
}