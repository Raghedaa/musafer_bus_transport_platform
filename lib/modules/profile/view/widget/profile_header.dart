import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import '../../../../core/constants/app_color.dart';
import '../../controller/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColor.grey.withOpacity(0.2),
              backgroundImage: controller.imagePath.value.isNotEmpty
                  ? FileImage(File(controller.imagePath.value))
                  : null,
              child: controller.imagePath.value.isEmpty
                  ? Icon(Icons.person, size: 40.sp, color: AppColor.primary)
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName.value,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      "+963 ${controller.userPhone.value}",
                      style: TextStyle(fontSize: 13.sp, color: AppColor.black),
                      textAlign: TextAlign.left, // 🔥 مهم
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Get.offAllNamed('/main-layout', arguments: 3);
              },
              icon: Icon(Icons.settings_outlined, color: AppColor.black),
            ),
          ],
        ),
      );
    });
  }
}