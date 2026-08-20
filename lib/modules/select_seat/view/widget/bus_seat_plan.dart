

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
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.darkgreen),
        );
      }

      if (controller.isLoadingError.value || !controller.hasVehicleData.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_bus_outlined,
                size: 80.sp,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16.h),
              Text(
                'لا توجد بيانات للمركبة لهذه الرحلة',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'لا يمكن عرض خريطة المقاعد',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      final vehicle = controller.vehicleModel.value;
      if (vehicle == null) {
        return const Center(
          child: Text('لا توجد بيانات للمركبة'),
        );
      }

      final layout = vehicle.layoutConfig;
      if (layout == null) {
        return const Center(
          child: Text('تنسيق المركبة غير متوفر'),
        );
      }

      final rows = layout['grid']?['rows'] as int? ?? 0;
      final cols = layout['grid']?['columns'] as int? ?? 0;

      if (rows == 0 || cols == 0) {
        return const Center(
          child: Text('لا توجد مقاعد متاحة'),
        );
      }

      final staticElements = layout['static_elements'] as List? ?? [];
      final aisleElement = staticElements.firstWhereOrNull((e) => e['type'] == "aisle");

      final aisleCol = aisleElement?['column'] as int?;
      final rowStart = aisleElement?['row_start'] as int? ?? 1;
      final rowEnd = aisleElement?['row_end'] as int? ?? rows;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: GridView.builder(
          itemCount: (rows * cols).toInt(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols.toInt(),
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            int row = (index ~/ cols) + 1;
            int col = (index % cols) + 1;

            final bool hasAisle = row >= rowStart && row <= rowEnd && aisleCol != null;

            if (hasAisle && col == aisleCol) {
              return const SizedBox();
            }

            String seatLabel = controller.getSeatLabel(row, col);
            if (seatLabel.isEmpty) return const SizedBox();

            return SeatItem(seatNumber: seatLabel);
          },
        ),
      );
    });
  }
}