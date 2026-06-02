import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../../data/models/subscription_plan_model.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15.r),

        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(plan.companyName[0],
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primary)),
            ),
            SizedBox(width: 15.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  Text("${plan.totalTrips} Trips • ${plan.validityDays} Days",
                      style: TextStyle(fontSize: 11.sp, color: AppColor.grey)),
                  Text(plan.companyName, style: TextStyle(fontSize: 10.sp, color: AppColor.darkgreen)),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${plan.price} ${'SP'.tr}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, size: 12.sp, color: AppColor.amber),
                    Text(plan.companyRating, style: TextStyle(fontSize: 10.sp)),                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}