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
    final isArabic = Get.locale?.languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
      child: SizedBox(
        height: 50.h,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: isArabic ? null : 0,
              right: isArabic ? 0 : null,
              child: IconButton(
                onPressed: () {
                  bool popped = Get.find<MainLayoutController>().popExplore();
                  if (!popped) {
                    Get.find<MainLayoutController>().changePage(2);
                  }
                },                icon: Icon(
                  Icons.adaptive.arrow_back_rounded,
                  size: 20.sp,
                  color: AppColor.black,
                ),
              ),
            ),

            Text(
              "Select Seat".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}