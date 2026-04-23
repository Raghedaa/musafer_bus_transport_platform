import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import 'package:musafer/data/models/trip_result_model.dart';
import '../../../../../routes/app_routes/app_routes.dart';
import '../../../../main_layout/controller/main_layout_controller.dart';
import '../../../../select_seat/controllers/select_seat_controller.dart';
import '../../../../select_seat/view/screen/select_seat_screen.dart';
import 'trip_card_header.dart';
import 'trip_card_time_line.dart';

class TripCardMain extends StatelessWidget {
  final TripResultModel tripResultModel;

  const TripCardMain({super.key, required this.tripResultModel});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          SelectSeatController.staticTrip = tripResultModel;
          Get.toNamed(AppRoute.trip_details);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              TripCardHeader(tripResultModel: tripResultModel),
              // نمرر البيانات للـ Header
              SizedBox(height: 20.h),
              TripCardTimeLine(tripResultModel: tripResultModel),
              // نمرر البيانات للـ Timeline
              SizedBox(height: 20.h),

              CustomButton(
                text: "Select Seats".tr,
                onPressed: () {
                  SelectSeatController.staticTrip = tripResultModel;

                  if (Get.isRegistered<SelectSeatController>()) {
                    Get.delete<SelectSeatController>();
                  }

                  Get.put(SelectSeatController());

                  Get.find<MainLayoutController>().pushToExplore(
                    const SelectSeatScreen(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
