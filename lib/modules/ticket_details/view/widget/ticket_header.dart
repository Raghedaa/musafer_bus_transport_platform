import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../core/constants/app_color.dart';
import '../../../main_layout/controller/main_layout_controller.dart';

class TicketHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(height: 40.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () {
                    Get.find<MainLayoutController>().popExplore();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: AppColor.black,
                  ),
                ),
              ),
              Text(
                "Your Ticket".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      );
    });
  }
}
