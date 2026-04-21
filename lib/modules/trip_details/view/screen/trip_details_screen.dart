import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text("Trip Details", style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined, color: AppColor.black))],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripDetailsCard(trip: controller.trip),
            SizedBox(height: 25.h),
            const AmenitiesSection(),
            SizedBox(height: 25.h),
            const DriverProfileCard(),
            SizedBox(height: 100.h), // مساحة للزر السفلي
          ],
        ),
      ),
      bottomSheet: _buildBottomPriceSection(),
    );
  }

  Widget _buildBottomPriceSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
              Text("TOTAL ESTIMATED", style: TextStyle(fontSize: 10.sp, color: AppColor.grey)),
              Text("\$${controller.trip.price}", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColor.darkgreen)),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: CustomButton(
              text: "Select Seats",
              onPressed: () => Get.toNamed('/select_seat', id: 1),
            ),
          ),
        ],
      ),
    );
  }
}