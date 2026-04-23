import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../../../../routes/app_routes/app_routes.dart';

class TripSearchHeader extends StatelessWidget {
  const TripSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Where to?".tr,
                    style: TextStyle(fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black)),
                Text("Find your next intercity journey".tr,
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColor.grey)),
              ],
            ),
            CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColor.grey.withOpacity(0.2),
              child: IconButton(icon: Icon(
                  Icons.person_outline, color: AppColor.black, size: 28.r),
                onPressed: () =>
                    Get.offAllNamed(AppRoute.main_layout, arguments: 4),

              ),
            )
          ],
        );
    } );}
}