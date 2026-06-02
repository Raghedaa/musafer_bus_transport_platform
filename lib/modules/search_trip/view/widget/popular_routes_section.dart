import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/trip_card/trip_card_main.dart';
import '../../../../data/models/trip_model.dart';
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
          if (controller.isPopularLoading.value) {
            return Center(child: CircularProgressIndicator(color: AppColor.darkgreen));
          }

          if (controller.popularTrips.isEmpty) {
            return Center(child: Text("No popular routes found".tr));
          }


          return Column(
            children: controller.popularTrips.map((trip) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: TripCardMain(tripmodel: trip),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}