import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bus Amenities".tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAmenityItem(Icons.wifi, "WI-FI".tr),
            _buildAmenityItem(Icons.ac_unit, "AIR CON".tr),
            _buildAmenityItem(Icons.usb, "USB PORT".tr),
            _buildAmenityItem(Icons.fastfood_outlined, "SNACKS".tr),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return Container(
      width: 75.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(15.r)),
      child: Column(
        children: [
          Icon(icon, color: AppColor.darkgreen, size: 24.sp),
          SizedBox(height: 5.h),
          Text(label, style: TextStyle(fontSize: 10.sp, color: AppColor.grey)),
        ],
      ),
    );
  }
}