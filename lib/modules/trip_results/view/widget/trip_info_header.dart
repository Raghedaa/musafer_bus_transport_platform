import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../controllers/trip_results_controller.dart';

class TripInfoHeader extends GetView<TripResultsController> {
  const TripInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
        children: [
          IconButton(
            onPressed: () => Get.back(id: 1),
            icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: AppColor.black),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Trip Results",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                Obx(() => Text(
                  "${controller.travelDate.value} • ${controller.passengers.value}",
                  style: TextStyle(fontSize: 12.sp, color: AppColor.grey),
                )),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, size: 24.sp),
          ),
        ],

    );
  }
}