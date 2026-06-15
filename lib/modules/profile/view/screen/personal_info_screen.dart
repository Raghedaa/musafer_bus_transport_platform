import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_button.dart';
import '../../../../core/utils/validators/auth_validator.dart';
import '../../controller/personal_info_controller.dart';
import '../widget/personal_info/personal_info_form.dart';
import '../widget/personal_info/personal_info_header.dart';


class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // يفضل ربط الـ Controller عبر Binding، لكن هذا يعمل أيضاً
    final controller = Get.put(PersonalInfoController());

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(title: Text("Personal Information".tr), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColor.darkgreen));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              const Center(child: PersonalInfoHeader()),
              SizedBox(height: 25.h),
              const PersonalInfoForm(),
              SizedBox(height: 20.h),
              CustomButton(
                text: "Save".tr,
                onPressed: () => controller.saveChanges(),
              ),
              SizedBox(height: 25.h),
            ],
          ),
        );
      }),
    );
  }
}