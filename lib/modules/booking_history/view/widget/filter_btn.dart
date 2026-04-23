import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/booking_history_controller.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final BookingHistoryController controller;

  const FilterButton({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      bool isSelected = controller.selectedFilter.value == label;

      return GestureDetector(
        onTap: () => controller.changeFilter(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primary : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColor.primary : Colors.transparent,
            ),
          ),
          child: Text(
            label.tr,
            style: TextStyle(
              color: isSelected ? AppColor.white : AppColor.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    });
  }
}