import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controllers/select_seat_controller.dart';


class SelectSeatHeader extends GetView<SelectSeatController> {
  const SelectSeatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => Get.back(id: 1),
              icon: const Icon(Icons.arrow_back_ios)),
          Column(
            children: [
              Text("Select Seat", style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Text("Route 402 • Executive",
                  style: TextStyle(fontSize: 12.sp, color: AppColor.grey)),
            ],
          ),
          const Icon(Icons.info_outline),
        ],
      ),
    );
  }
}