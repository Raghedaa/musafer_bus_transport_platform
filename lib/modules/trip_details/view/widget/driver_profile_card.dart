import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class DriverProfileCard extends StatelessWidget {
  const DriverProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Driver Profile", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: AppColor.grey.withOpacity(0.1),
                child: Icon(Icons.person, color: AppColor.darkgreen),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Capt. Marcus Sterling", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14.sp, color: AppColor.grey),
                        SizedBox(width: 5.w),
                        Text("+963 9xx xxx xxx", style: TextStyle(color: AppColor.grey, fontSize: 13.sp)),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.verified_user, color: AppColor.darkgreen, size: 20.sp),
            ],
          ),
        ),
      ],
    );
  }
}