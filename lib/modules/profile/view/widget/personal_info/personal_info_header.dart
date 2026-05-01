import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../controller/personal_info_controller.dart';


class PersonalInfoHeader extends GetView<PersonalInfoController> {
  const PersonalInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          GestureDetector(
            onTap: controller.pickImage,
            child: CircleAvatar(
              radius: 45.r,
              backgroundImage: controller.imagePath.value.isNotEmpty
                  ? FileImage(File(controller.imagePath.value))
                  : null,
              backgroundColor: AppColor.grey.withOpacity(0.2),
              child: controller.imagePath.value.isEmpty
                  ? Icon(Icons.camera_alt, size: 30.sp)
                  : null,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Edit Profile".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    });
  }
}