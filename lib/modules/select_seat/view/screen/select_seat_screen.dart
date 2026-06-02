import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/select_seat_controller.dart';
import '../widget/bus_seat_plan.dart';
import '../widget/payment_container.dart';
import '../widget/seat_legend_row.dart';
import '../widget/select_seat_header.dart';

class SelectSeatScreen extends GetView<SelectSeatController> {
  const SelectSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.darkgreen,
          onRefresh: () async {
            await controller.fetchSeatsData();
          },
          child: Column(
            children: [
              const SelectSeatHeader(),
              const SeatLegendRow(),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: AppColor.darkgreen));
                  }
                  return const BusSeatPlan();
                }),
              ),

              const PaymentContainer(),
            ],
          ),
        ),
      ),
    );
  }
}