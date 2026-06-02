import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import '../../../../core/services/api_service.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../../select_seat/controllers/select_seat_controller.dart';
import '../../../select_seat/view/screen/select_seat_screen.dart';
import '../../controllers/trip_details_controller.dart';
import '../widget/driver_profile_card.dart';
import '../../../trip_details/view/widget/rest_area_section.dart';
import '../widget/route_details_section.dart';
import '../widget/trip_details_card.dart';


class TripDetailsScreen extends GetView<TripDetailsController> {

  const TripDetailsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final TripDetailsController controller = Get.put(TripDetailsController());

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Obx(() {
          if (!controller.isDataLoaded.value || controller.trip.value == null) {
            return Center(child: CircularProgressIndicator(color: AppColor.primary));
          }

          print("🔄 UI: isDataLoaded=${controller.isDataLoaded.value}, hasTrip=${controller.trip.value != null}");

          final trip = controller.trip.value!;

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppColor.primary,
                  onRefresh: () async {
                    await controller.refreshTripDetails();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        TripDetailsCard(trip: trip),
                        SizedBox(height: 10.h),
                        RouteDetailsSection(trip: trip),
                        SizedBox(height: 10.h),
                        if (trip.restAreas.isNotEmpty) ...[
                          RestAreaSection(restAreas: trip.restAreas),
                          SizedBox(height: 10.h),
                        ],
                        DriverProfileCard(trip: trip),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]
                ),
                child: CustomButton(
                  text: "Select Seats".tr,
                  onPressed: () async {
                    if (controller.trip.value == null) return;


                    SelectSeatController.staticTrip = controller.trip.value;

                    if (Get.isRegistered<SelectSeatController>()) {
                      Get.delete<SelectSeatController>();
                    }
                    Get.put(SelectSeatController());

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.find<MainLayoutController>().pushToExplore(const SelectSeatScreen());
                    });
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}