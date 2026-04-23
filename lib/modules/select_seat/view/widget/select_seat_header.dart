import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../controllers/select_seat_controller.dart';

class SelectSeatHeader extends GetView<SelectSeatController> {
  const SelectSeatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Get.find<MainLayoutController>().popExplore();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20.sp,
                color: AppColor.black,
              ),
            ),
            Column(
              children: [
                Text(
                  "Select Seat".tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                Text(
                  "Route 402 • Executive".tr,
                  style: TextStyle(fontSize: 12.sp, color: AppColor.black),
                ),
              ],
            ),
            const Icon(Icons.info_outline),
          ],
        ),
      );
    });
  }
}
