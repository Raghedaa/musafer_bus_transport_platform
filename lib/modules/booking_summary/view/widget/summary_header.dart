import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../controllers/booking_summary_controller.dart';

class SummaryHeader extends StatelessWidget {
  const SummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10.h,
          bottom: 10.h,
        ),
        child: Row(
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
            SizedBox(width: 45.w),
            Text(
              "Booking Summary".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class PNRCardWidget extends GetView<BookingSummaryController> {
  const PNRCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Text(
              "UNIQUE PNR NUMBER".tr,
              style: TextStyle(fontSize: 12.sp, color: AppColor.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.pnrNumber,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.copyPNR(),
                  icon: Icon(
                    Icons.copy,
                    size: 20.sp,
                    color: AppColor.grey.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
