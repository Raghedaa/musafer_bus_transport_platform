import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.darkgreen,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Remaining Trips", style: TextStyle(color: AppColor.white.withOpacity(0.6), fontSize: 14.sp)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: AppColor.white.withOpacity(0.4), borderRadius: BorderRadius.circular(20.r)),
                child: Text("PREMIUM PLUS", style: TextStyle(color: AppColor.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: 5.h),
          Text("12 Trips", style: TextStyle(color: AppColor.white, fontSize: 32.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 15.h),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor:  AppColor.white.withOpacity(0.2),
            color: AppColor.white,
            minHeight: 6.h,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 15.h),
          Text("Valid until Oct 24, 2024 • Global Access", style: TextStyle(color: AppColor.white.withOpacity(0.6), fontSize: 11.sp)),
        ],
      ),
    );
  }
}