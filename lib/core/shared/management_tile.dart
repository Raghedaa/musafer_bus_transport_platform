import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_color.dart';

class ManagementTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color? textColor;
  final Color? bgColor;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? borderColor;
  final double? borderWidth;

  const ManagementTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.textColor,
    this.bgColor,
    this.trailing,
    required this.onTap,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: bgColor ?? AppColor.white,
          borderRadius: BorderRadius.circular(15.r),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth ?? 1.w)
              : null,
          boxShadow: [
            if (bgColor == null || bgColor == AppColor.white)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // الأيقونة مع الخلفية الدائرية
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 15.w),
            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: textColor?.withOpacity(0.7) ?? Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // الأيقونة في النهاية
            trailing ?? Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}