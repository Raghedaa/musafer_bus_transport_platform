import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import 'package:musafer/modules/search_trip/view/widget/trip_search_card/date_passengers_row.dart';
import 'package:musafer/modules/search_trip/view/widget/trip_search_card/destination_field.dart';
import 'package:musafer/modules/search_trip/view/widget/trip_search_card/origin_field.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';

import '../../../../main_layout/controller/main_layout_controller.dart';
import '../../../../trip_results/view/screen/trip_results_screen.dart';
import '../../../controllers/search_controller.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
       return Container(
        height: 320.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    const OriginField(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Divider(
                          color: AppColor.grey.withOpacity(0.3), thickness: 1),
                    ),
                    const DestinationField(),
                  ],
                ),
                Positioned(
                  right: 10.w,
                  top: 40.h,
                  child: _buildSwapButton(),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            const DateAndPassengersRow(),
            SizedBox(height: 20.h),
            CustomButton(
              text: "Find Trips".tr,
              onPressed: () {
                // Get.toNamed('/results', id: MainLayoutController.exploreNavId);
                final mainController = Get.find<MainLayoutController>();
                mainController.pushToExplore(const TripResultsScreen());
              },
            ),
          ],
        ),
      );
    });
  }
}


Widget _buildSwapButton() {
  final controller = Get.find<TripSearchController>();
  return GestureDetector(
    onTap: () => controller.swapLocations(),
    child: Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.swap_vert,
        color: AppColor.primary,
        size: 20.sp,
      ),
    ),
  );
}
