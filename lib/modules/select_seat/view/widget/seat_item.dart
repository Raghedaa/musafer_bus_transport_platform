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
      final seat = controller.vehicleModel.value?.seats.firstWhereOrNull((s) => s.label == seatNumber);
      if (seat == null) return const SizedBox();

      bool isBooked = seat.status == 3;
      bool isSelected = controller.selectedSeats.contains(seatNumber);
      bool isFemale = seat.gender?.toLowerCase() == 'female';
      bool isMale = seat.gender?.toLowerCase() == 'male';

      Color getBgColor() {
        if (isSelected) return const Color(0xFF384D3B);
        if (isBooked) {
          if (isFemale) return const Color(0xFFFCE4EC);
          if (isMale) return const Color(0xFFE3F2FD);
          return const Color(0xFFE0E0E0);
        }
        return Colors.white;
      }

      Color getBorderColor() {
        if (isSelected) return const Color(0xFF384D3B);
        if (isBooked) {
          if (isFemale) return const Color(0xFFF06292);
          if (isMale) return const Color(0xFF64B5F6);
          return const Color(0xFFBDBDBD);
        }
        return const Color(0xFFBDBDBD);
      }

      return GestureDetector(
        onTap: isBooked ? null : () => controller.toggleSeat(seatNumber),
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: getBgColor(),
            border: Border.all(color: getBorderColor(), width: 1.w),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: isBooked
                ? (isFemale || isMale)
                ? Icon(
              isFemale ? Icons.person : Icons.person,
              color: isFemale ? const Color(0xFFD81B60) : const Color(0xFF1E88E5),
              size: 20.sp,
            )
                : Icon(Icons.lock, color: const Color(0xFF9E9E9E), size: 18.sp)
                : Text(
              seatNumber,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF757575),
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      );
    });
  }
}