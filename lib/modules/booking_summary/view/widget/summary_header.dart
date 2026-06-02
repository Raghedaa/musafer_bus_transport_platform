import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../main_layout/controller/main_layout_controller.dart';

class SummaryHeader extends StatelessWidget {
  const SummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 10.h,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              bool popped = Get.find<MainLayoutController>().popExplore();
              if (!popped) {
                Get.find<MainLayoutController>().changePage(2);
              }
            },
            icon: Icon(
              Icons.adaptive.arrow_back_rounded,
              size: 20.sp,
              color: AppColor.black,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                "Booking Summary".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
            ),
          ),

          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}