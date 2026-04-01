import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, this.title = "Welcome", this.subtitle = "Plan your next intercity journey"});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.darkgreen,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Icon(Icons.directions_bus, color: AppColor.white, size: 40.sp),
        ),
        SizedBox(height: 16.h),
        Text(title, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Text(subtitle, style: TextStyle(fontSize: 14.sp, color: AppColor.grey)),
      ],
    );
  }
}