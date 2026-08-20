import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controllers/select_seat_controller.dart';


class SeatLegendRow extends GetView<SelectSeatController> {
  const SeatLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legendIconItem(
                    "Female".tr, Icons.person, const Color(0xFFD81B60)),
                _legendIconItem(
                    "Male".tr, Icons.person, const Color(0xFF1E88E5)),
                _legendIconItem(
                    "Blocked".tr, Icons.lock, const Color(0xFF9E9E9E)),
              ],
            ),

            SizedBox(height: 12.h),
            Divider(
                color: AppColor.black12,
                thickness: 1,
                indent: 40.w,
                endIndent: 40.w),
            SizedBox(height: 12.h),

            // ✅ صف واحد يجمع Window + (Your Seat في وضع التعديل) + Extra Space
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legendIconItem(
                    "Window".tr, Icons.grid_view_rounded, AppColor.grey),

                // 🟣 يظهر في المنتصف فقط في وضع التعديل
                if (controller.isModifyMode)
                  _legendColorItem(
                    "your_seat".tr,
                    AppColor.darkgreen.withOpacity(0.6),
                    icon: Icons.push_pin,
                  ),

                _legendIconItem(
                    "Extra Space".tr, Icons.auto_awesome, AppColor.amber),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _legendColorItem(String text, Color color,
      {bool isBorder = false, IconData? icon}) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
            border: isBorder
                ? Border.all(color: Colors.grey.shade400, width: 1)
                : null,
          ),
          child: icon != null
              ? Icon(icon, size: 10.sp, color: Colors.white)
              : null,
        ),
        SizedBox(width: 6.w),
        Text(text,
            style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.black87,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _legendIconItem(String text, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: iconColor),
        SizedBox(width: 6.w),
        Text(text,
            style: TextStyle(fontSize: 11.sp, color: AppColor.black87)),
      ],
    );
  }
}