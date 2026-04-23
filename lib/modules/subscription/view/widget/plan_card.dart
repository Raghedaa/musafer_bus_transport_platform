import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../../../../data/models/subscription_plan_model.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: isSelected ? AppColor.darkgreen : Colors.transparent,
                width: 2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColor.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    _getIcon(plan.icon),
                    color: AppColor.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                      Text(
                        plan.trips,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColor.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // السعر
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${plan.oldPrice}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColor.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      "\$${plan.price}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (plan.isPopular == true)
            Positioned(
              top: -10.h,
              right: 15.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.darkgreen,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  "MOST POPULAR".tr,
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'bus':
        return Icons.directions_bus_filled_outlined;
      case 'medal':
        return Icons.emoji_events_outlined;
      case 'building':
        return Icons.business_outlined;
      default:
        return Icons.star_outline;
    }
  }
}