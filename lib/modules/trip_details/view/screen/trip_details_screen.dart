import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import '../../../../data/models/trip_result_model.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../../select_seat/controllers/select_seat_controller.dart';
import '../../../select_seat/view/screen/select_seat_screen.dart';
import '../../controllers/trip_details_controller.dart';
import '../widget/amenities_section.dart';
import '../widget/driver_profile_card.dart';
import '../widget/trip_details_card.dart';

class TripDetailsScreen extends GetView<TripDetailsController> {

  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h,),
            TripDetailsCard(trip: controller.trip),
            SizedBox(height: 25.h),
            const AmenitiesSection(),
            SizedBox(height: 25.h),
            const DriverProfileCard(),
            // SizedBox(height: 50.h),
          ],
        ),
      ),
      bottomSheet: _buildBottomPriceSection(),
    );
  }

  Widget _buildBottomPriceSection() {
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TOTAL ESTIMATED".tr, style: TextStyle(fontSize: 10.sp, color: AppColor.grey)),
              Text("\$${controller.trip.price}", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColor.darkgreen)),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: CustomButton(
              text: "Select Seats".tr,
              onPressed: () {
                // SelectSeatController.staticTrip = tripResultModel;
                //
                // if (Get.isRegistered<SelectSeatController>()) {
                //   Get.delete<SelectSeatController>();
                // }
                //
                // Get.put(SelectSeatController());
                //
                // Get.find<MainLayoutController>().pushToExplore(const SelectSeatScreen());
              }
            ),
          ),
        ],
      ),
    );
  }
}