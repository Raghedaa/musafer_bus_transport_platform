import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/trip_card/trip_card_main.dart';
import '../../controllers/search_controller.dart';

class PopularRoutesSection extends StatelessWidget {
  final TripSearchController controller;

  const PopularRoutesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Popular Routes".tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 15.h),

        Obx(() {
          if (controller.isPopularLoading.value && controller.popularTrips.isEmpty) {
            return Center(child: CircularProgressIndicator(color: AppColor.darkgreen));
          }

          if (controller.popularTrips.isEmpty) {
            return Center(child: Text("No popular routes found".tr));
          }

          return ListView.builder(
           shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.popularTrips.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.popularTrips.length) {
                return Obx(() => controller.isLoadingMore.value
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColor.darkgreen),
                  ),
                )
                    : const SizedBox.shrink());
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: TripCardMain(tripmodel: controller.popularTrips[index]),
              );
            },
          );
        }),
      ],
    );
  }
}