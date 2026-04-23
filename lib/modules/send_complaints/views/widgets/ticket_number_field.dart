import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_text_form_field.dart';

class TicketNumberField extends StatelessWidget {
  final TextEditingController controller;
  const TicketNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ticket Number".tr,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.black),
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          hint: "12****4",
        ),
      ],
    );
  }
}