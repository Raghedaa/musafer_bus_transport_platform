
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
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
        child: Obx(() {
          if (controller.isLoadingError.value || !controller.hasVehicleData.value) {
            return _buildErrorWidget();
          }

          return RefreshIndicator(
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
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.darkgreen,
                        ),
                      );
                    }
                    return const BusSeatPlan();
                  }),
                ),
                const PaymentContainer(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_bus_outlined,
                size: 100.sp,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 20.h),
              Text(
                'لا توجد بيانات للمركبة',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'هذه الرحلة لا تحتوي على معلومات المقاعد',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 30.h),

              SizedBox(height: 20.h),
              TextButton.icon(
                onPressed: () {
                  if (SelectSeatController.staticTrip != null) {
                    controller.fetchVehicleDataFromServer(
                      SelectSeatController.staticTrip!.id,
                    );
                  }
                },
                icon: const Icon(Icons.refresh, color: AppColor.darkgreen),
                label: Text(
                  'محاولة مرة أخرى',
                  style: TextStyle(
                    color: AppColor.darkgreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}