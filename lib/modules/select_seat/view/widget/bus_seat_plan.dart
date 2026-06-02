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
      if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

      final vehicle = controller.vehicleModel.value!;
      final layout = vehicle.layoutConfig;

      final rows = layout['grid']['rows'] as int;
      final cols = layout['grid']['columns'] as int;
      final aisle = (layout['static_elements'] as List).firstWhereOrNull((e) => e['type'] == "aisle")?['column'];

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
            if (col == aisle) return const SizedBox();
            String seatLabel = controller.getSeatLabel(row, col);
            if (seatLabel.isEmpty) return const SizedBox();
            return SeatItem(seatNumber: seatLabel);
          },
        ),
      );
    });
  }
}