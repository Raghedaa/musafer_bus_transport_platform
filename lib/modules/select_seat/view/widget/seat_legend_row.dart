import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controllers/select_seat_controller.dart';


class SeatLegendRow extends GetView<SelectSeatController> {
  const SeatLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem("Available", AppColor.white, isBorder: true),
          _legendItem("Selected", AppColor.darkgreen),
          _legendItem("Booked", AppColor.grey.withOpacity(0.3)),
        ],
      ),
    );
  }


  Widget _legendItem(String text, Color color, {bool isBorder = false}) {
    return Row(
      children: [
        Container(
          width: 16.w, height: 16.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
            border: isBorder ? Border.all(color: AppColor.grey.withOpacity(0.3)) : null,
          ),
        ),
        SizedBox(width: 8.w),
        Text(text, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

}