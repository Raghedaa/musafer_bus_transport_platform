import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/select_seat/view/widget/seat_item.dart';
import '../../controllers/select_seat_controller.dart';

class BusSeatPlan extends GetView<SelectSeatController> {
  const BusSeatPlan({super.key});

  @override
  Widget build(BuildContext context) {
    int rows = 6;
    int columns = 5;
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.grey, width: 1),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: GridView.builder(
          itemCount: rows * columns,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (context, index) {
            if (index % 5 == 2) return const SizedBox();

            int row = index ~/ 5;
            int col = index % 5;

            int adjustedCol = col > 2 ? col - 1 : col;

            String seatLabel =
                "${row + 1}${String.fromCharCode(65 + adjustedCol)}";

            return SeatItem(seatNumber: seatLabel);
          },
        ),
      );
    });
  }
}
