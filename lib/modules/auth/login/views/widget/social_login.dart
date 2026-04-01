import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/constants/app_image.dart'; // تأكد أن google_logo معرف هنا

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                "OR CONTINUE WITH",
                style: TextStyle(fontSize: 10.sp, color: AppColor.grey),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: _buildSocialBtn(
                label: "Google",
                customIcon: SvgPicture.asset(
                  AppImageAsset.google_logo,
                  height: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 15.w),

          ],
        ),
      ],
    );
  }

  Widget _buildSocialBtn({
    required String label,
    dynamic icon,
    Color? iconColor,
    Widget? customIcon,
  }) {
    return OutlinedButton.icon(
      onPressed: () {
        // أضف الأكشن هنا
      },
      icon: customIcon ??
          FaIcon(
            icon,
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