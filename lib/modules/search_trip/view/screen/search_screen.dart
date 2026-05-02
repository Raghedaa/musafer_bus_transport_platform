import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';
import 'package:musafer/modules/search_trip/view/widget/search_header.dart';
import '../widget/trip_search_card/search_card.dart';

class TripSearchScreen extends StatelessWidget {
  const TripSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TripSearchController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TripSearchHeader(),
                SizedBox(height: 25.h),
                const SearchCard(),
                SizedBox(height: 25.h),

                // Popular Routes
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Routes".tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black, // رح يتغير فوراً للأبيض بفضل Obx
                      ),
                    ),
                    Text(
                      "View All".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.primaryGrey,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),

    );
  }
}