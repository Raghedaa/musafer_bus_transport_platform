import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(
        label.tr,
        style: TextStyle(
          color: AppColor.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }
}
