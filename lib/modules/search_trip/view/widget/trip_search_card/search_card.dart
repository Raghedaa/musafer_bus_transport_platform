import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../../../../core/shared/custom_snackbar.dart';
import '../../../../main_layout/controller/main_layout_controller.dart';
import '../../../../trip_results/controllers/trip_results_controller.dart';
import '../../../../trip_results/view/screen/trip_results_screen.dart';
import '../../../controllers/search_controller.dart';
import 'date_passengers_row.dart';
import 'destination_field.dart';
import 'origin_field.dart';

class SearchCard extends GetView<TripSearchController> {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isExpanded = controller.isCardExpanded.value;

      return InkWell(
        onTap: isExpanded ? null : () => controller.toggleSearchCard(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? 270.h : 60.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: isExpanded
                ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Column(
                      children: [
                        const OriginField(),
                        SizedBox(height: 12.h),
                        const DestinationField(),
                      ],
                    ),
                    Positioned(
                      right: 10.w,
                      top: 48.h,
                      child: _buildSwapButton(),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                const DateAndPassengersRow(),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up, color: AppColor.primary),
                      onPressed: () => controller.toggleSearchCard(),
                    ),
                    Expanded(
                      child:
                      CustomButton(
                        text: "Find Trips".tr,
                        onPressed: () async {
                          if (controller.selectedOriginCity.value == null || controller.selectedDestinationCity.value == null) {
                            CustomSnackBar.showError("Please select cities".tr);
                            return;
                          }

                          if (Get.isRegistered<TripResultsController>()) {
                            Get.delete<TripResultsController>();
                          }

                          final tripCtrl = Get.put(TripResultsController());

                          tripCtrl.setSearchParams(
                            originId: controller.selectedOriginCity.value!.id.toString(),
                            originName: controller.selectedOriginCity.value!.name,
                            destinationId: controller.selectedDestinationCity.value!.id.toString(),
                            destinationName: controller.selectedDestinationCity.value!.name,
                            date: controller.departureDate.value,
                            time: controller.departureTime.value == "Select Time" ? "" : controller.departureTime.value,
                          );

                          Get.find<MainLayoutController>().pushToExplore(const TripResultsScreen());
                        },
                      )
                    ),
                  ],
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.search, color: AppColor.primary, size: 22.sp),
                    SizedBox(width: 10.w),
                    Text(
                      "${controller.selectedOriginCity.value?.name.tr ?? 'Select Origin'.tr} → ${controller.selectedDestinationCity.value?.name.tr ?? 'Anywhere'.tr}",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.black),
                    ),
                  ],
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColor.grey, size: 22.sp),
              ],
            ),
          ),
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Icon(Icons.swap_vert, color: AppColor.primary, size: 20.sp),
    ),
  );
}