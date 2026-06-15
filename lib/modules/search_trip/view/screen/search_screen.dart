import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/search_controller.dart';
import '../widget/search_header.dart';
import '../widget/trip_search_card/search_card.dart';
import '../widget/popular_routes_section.dart';


class TripSearchScreen extends StatelessWidget {
  const TripSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripSearchController());

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.darkgreen,
          onRefresh: () async {
            await controller.fetchPopularTrips(isLoadMore: false);
            },
          child: SingleChildScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                const TripSearchHeader(),
                SizedBox(height: 25.h),
                const SearchCard(),
                SizedBox(height: 25.h),
                PopularRoutesSection(controller: controller),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}