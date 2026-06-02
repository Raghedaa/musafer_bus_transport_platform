import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../controllers/trip_results_controller.dart';

class TripInfoHeader extends GetView<TripResultsController> {
  const TripInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isArabic = Get.locale?.languageCode == 'ar';
      String displayTime = controller.travelTime.value;

      return SizedBox(
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
                  Get.find<MainLayoutController>().popExplore();
                },
                icon: Icon(
                  Icons.adaptive.arrow_back_rounded,
                  size: 20.sp,
                  color: AppColor.black,
                ),
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Trip Results".tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${controller.travelDate.value.tr} $displayTime",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.grey,
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