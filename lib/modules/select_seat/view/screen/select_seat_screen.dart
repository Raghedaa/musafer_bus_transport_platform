import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/select_seat_controller.dart';
import '../widget/bus_seat_plan.dart';
import '../widget/payment_bottom_sheet.dart';
import '../widget/seat_legend_row.dart';
import '../widget/select_seat_header.dart';

class SelectSeatScreen extends GetView<SelectSeatController> {
  const SelectSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const PaymentBottomSheet(),
      body: SafeArea(
        child: Column(
          children: [
            const SelectSeatHeader(),
            const SeatLegendRow(),
            const Expanded(child: BusSeatPlan()),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}