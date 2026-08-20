
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
      final seat = controller.vehicleModel.value?.seats
          .firstWhereOrNull((s) => s.label == seatNumber);
      if (seat == null) return const SizedBox();

      final displayType = controller.getSeatDisplayType(seatNumber, seat.status);

      bool isFemale = seat.gender?.toLowerCase() == 'female';
      bool isMale = seat.gender?.toLowerCase() == 'male';

      Color bgColor;
      Color borderColor;
      Color textColor;
      Widget centerContent;
      bool isTappable = true;
      double borderWidth = 1.w;

      switch (displayType) {
        case SeatDisplayType.available:
          bgColor = AppColor.white;
          borderColor = AppColor.primaryGrey;
          textColor = const Color(0xFF757575);
          centerContent = Text(
            seatNumber,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          );
          break;

        case SeatDisplayType.selectedNew:
          bgColor = AppColor.darkgreen;
          borderColor = AppColor.darkgreen;
          textColor = Colors.white;
          centerContent = Text(
            seatNumber,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          );
          break;

        case SeatDisplayType.myOriginalSelected:
          bgColor = AppColor.darkgreen.withOpacity(0.6);
          borderColor = AppColor.darkgreen;
          textColor = Colors.white;
          borderWidth = 1.5.w;
          centerContent = Stack(
            children: [
              Center(
                child: Text(
                  seatNumber,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.push_pin,
                  size: 9.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          );
          break;

        case SeatDisplayType.myOriginalDeselected:
          bgColor = AppColor.darkgreen.withOpacity(0.12);
          borderColor = AppColor.darkgreen;
          textColor = AppColor.darkgreen;
          borderWidth = 2.w;
          centerContent = Text(
            seatNumber,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColor.darkgreen,
              decorationThickness: 2,
            ),
          );
          break;

        case SeatDisplayType.bookedByOthers:
          isTappable = false;
          if (isFemale) {
            bgColor = AppColor.femaleBookedBg;
            borderColor = AppColor.femaleBookedBorder;
          } else if (isMale) {
            bgColor = AppColor.maleBookedBg;
            borderColor = AppColor.maleBookedBorder;
          } else {
            bgColor = AppColor.unavailableBg;
            borderColor = AppColor.unavailableBorder;
          }
          textColor = const Color(0xFF757575);
          centerContent = (isFemale || isMale)
              ? Icon(
            Icons.person,
            color: isFemale
                ? const Color(0xFFD81B60)
                : const Color(0xFF1E88E5),
            size: 20.sp,
          )
              : Icon(Icons.lock,
              color: const Color(0xFF9E9E9E), size: 18.sp);
          break;
      }

      return GestureDetector(
        onTap: isTappable ? () => controller.toggleSeat(seatNumber) : null,
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: borderWidth),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(child: centerContent),
        ),
      );
    });
  }
}