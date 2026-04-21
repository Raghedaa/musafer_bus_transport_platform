import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_text_form_field.dart';

class TripNumberField extends StatelessWidget {
  final TextEditingController controller;
  const TripNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trip Number",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.black),
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: controller,
          hint: "e.g. BUS-8829", // نمرر الـ hint مباشرة
          // إذا أردت أيقونة يمكنك إضافتها هنا:
          // prefixIcon: Icons.directions_bus,
        ),
      ],
    );
  }
}