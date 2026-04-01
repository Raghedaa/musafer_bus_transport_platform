import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/modules/trip_results/view/widget/trip-route_card.dart';
import '../../controllers/trip_results_controller.dart';
import '../widget/trip_info_header.dart';
import '../widget/filter_chips_row.dart';
import '../widget/trip_card/trip_card_main.dart';

class TripResultsScreen extends GetView<TripResultsController> {
  const TripResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30.h,),
              const TripInfoHeader(),
              const TripRouteCard(),
              SizedBox(height: 15.h),
              const FilterChipsRow(),
              SizedBox(height: 10.h),
              Expanded(
                child: Obx(() => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.trips.length,
                  itemBuilder: (context, index) {
                    return TripCardMain(tripResultModel: controller.trips[index]);
                  },
                ))
              ),
            ],
          ),
        ),
    );
  }
}