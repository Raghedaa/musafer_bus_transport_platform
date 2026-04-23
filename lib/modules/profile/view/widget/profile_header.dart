import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import '../../../../core/constants/app_color.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColor.grey.withOpacity(0.2),
              child: Icon(Icons.person, size: 40.sp, color: AppColor.primary),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saria Al-Zoubi",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  Text(
                    "+963 9xx xxx xxx",
                    style: TextStyle(fontSize: 13.sp, color: AppColor.black),
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