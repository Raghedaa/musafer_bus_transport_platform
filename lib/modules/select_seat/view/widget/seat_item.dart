import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controllers/select_seat_controller.dart';

class SeatItem extends GetView<SelectSeatController> {
  final String seatNumber;

  const SeatItem({super.key, required this.seatNumber});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int status = controller.seatStatus[seatNumber] ?? 0;
      bool isSelected = controller.selectedSeats.contains(seatNumber);

      Color bgColor = AppColor.white;
      Widget? content;

      if (isSelected) {
        bgColor = AppColor.darkgreen;
        content = Text(
          seatNumber,
          style: const TextStyle(color: AppColor.white),
        );
      } else if (status == 1) {
        // شاب
        bgColor = AppColor.blue.withOpacity(0.3);
        bgColor = AppColor.blue.withOpacity(0.3);
        content = Icon(Icons.person, color: AppColor.blue, size: 20.sp);
      } else if (status == 2) {
        // فتاة
        bgColor = AppColor.pink.withOpacity(0.3);
        content = Icon(Icons.person, color: AppColor.pink, size: 20.sp);
      } else if (status == 3) {
        bgColor = AppColor.grey.withOpacity(0.3);
        content = Icon(
          Icons.lock_outline,
          color: AppColor.grey.withOpacity(0.3),
          size: 18.sp,
        );
      } else {
        content = Text(seatNumber, style: TextStyle(color: AppColor.grey));
      }

      return GestureDetector(
        onTap: ()  {
        print("TAPPED: $seatNumber");
        controller.toggleSeat(seatNumber);
      },
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColor.grey.withOpacity(0.2)),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.darkgreen.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: content,
        ),
      );
    });
  }
}
