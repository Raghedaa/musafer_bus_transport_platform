import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../widget/tracking_sheet.dart';

class TripTrackingScreen extends StatelessWidget {
  const TripTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. قسم الخريطة (حالياً خلفية ملونة)
          Container(
            width: double.infinity,
            height: 0.6.sh, // تأخذ 60% من ارتفاع الشاشة
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4a3427), Color(0xffd6a77a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Icon(Icons.directions_bus, size: 50.sp, color: Colors.white),
            ),
          ),

          // 2. الـ Custom AppBar
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(Icons.arrow_back_ios_new, () => Get.back()),
                Text(
                  "Trip Tracking",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.darkgreen),
                ),
                _buildCircleIcon(Icons.more_horiz, () {}),
              ],
            ),
          ),

          // 3. الـ Bottom Sheet (التفاصيل)
          const TrackingSheet(),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20.sp, color: AppColor.darkgreen),
      ),
    );
  }
}