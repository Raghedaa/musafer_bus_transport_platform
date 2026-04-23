import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musafer/core/constants/app_color.dart';

class CustomSocialButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Widget? customIcon;
  final VoidCallback onPressed;

  const CustomSocialButton({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.customIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: customIcon ??
          FaIcon(
            icon as FaIconData?,
            color: iconColor,
            size: 18.sp,
          ),
      label: Text(
        label,
        style: TextStyle(
          color: AppColor.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.black,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}