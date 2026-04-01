import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
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
          // جسم البطاقة الأساسي
          Container(
            margin: EdgeInsets.only(bottom: 15.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: isSelected ? const Color(0xFF3E4F36) : Colors.transparent,
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
                // الأيقونة (الباص أو الميدالية)
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    _getIcon(plan['icon']),
                    color: const Color(0xFF3E4F36),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                // النصوص (اسم الخطة والرحلات)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan['title'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        plan['trips'],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey,
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
                      "\$${plan['oldPrice']}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      "\$${plan['price']}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // علامة "MOST POPULAR" تظهر فقط إذا كانت الخطة مميزة
          if (plan['isPopular'] == true)
            Positioned(
              top: -10.h,
              right: 15.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E4F36),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  "MOST POPULAR",
                  style: TextStyle(
                    color: Colors.white,
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

  // دالة بسيطة لاختيار الأيقونة المناسبة بناءً على البيانات
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