import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controller/profile_controller.dart';

class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final String imagePath = Hive.box('user_box').get('profile_image', defaultValue: '');

    return Obx(() {
      final user = controller.userData;
      final hasData = user.isNotEmpty;

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColor.grey.withOpacity(0.2),

              backgroundImage: imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
              child: imagePath.isEmpty
                  ? Icon(Icons.person, size: 40.sp, color: AppColor.darkgreen)
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasData ? user['name'] : "Loading...",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    hasData ? "${"+963".tr} ${user['phone_number']}" : "",
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}