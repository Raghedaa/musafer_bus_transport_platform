
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../../../../data/models/trip_model.dart';
import '../../../../../routes/app_routes/app_routes.dart';
import '../../../modules/main_layout/controller/main_layout_controller.dart';
import '../../../modules/select_seat/controllers/select_seat_controller.dart';
import '../../../modules/select_seat/view/screen/select_seat_screen.dart';
import '../../../modules/trip_details/controllers/trip_details_controller.dart';
import '../../../modules/trip_details/view/screen/trip_details_screen.dart';
import 'trip_card_header.dart';
import 'trip_card_time_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../../../../data/models/trip_model.dart';
import '../../../modules/main_layout/controller/main_layout_controller.dart';
import '../../../modules/select_seat/controllers/select_seat_controller.dart';
import '../../../modules/select_seat/view/screen/select_seat_screen.dart';
import '../../../modules/trip_details/controllers/trip_details_controller.dart';
import '../../../modules/trip_details/view/screen/trip_details_screen.dart';
import 'trip_card_header.dart';
import 'trip_card_time_line.dart';

class TripCardMain extends StatelessWidget {
  final TripModel tripmodel;
  const TripCardMain({super.key, required this.tripmodel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TripCardHeader(tripmodel: tripmodel),
          SizedBox(height: 20.h),
          TripCardTimeLine(tripResultModel: tripmodel),
          SizedBox(height: 20.h),


          CustomButton(
            text: "View Details".tr,
            onPressed: () {
              if (Get.isRegistered<TripDetailsController>()) {
                Get.delete<TripDetailsController>();
              }
              final controller = Get.put(TripDetailsController());
              controller.loadTripDataById(tripmodel.id);
              Get.find<MainLayoutController>().pushToExplore(const TripDetailsScreen());
            },
          ),
        ],
      ),
    );
  }
}
