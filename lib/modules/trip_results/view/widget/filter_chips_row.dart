import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/trip_results_controller.dart';

class FilterChipsRow extends GetView<TripResultsController> {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {"label": "No Filter", "icon": Icons.tune},
      {"label": "Cheapest Price", "icon": null},
      {"label": "Highest Rated", "icon": null},
    ];

    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];

          return Obx(() {
            bool isSelected = controller.selectedFilter.value == filter['label'];

            return Padding(
              padding: EdgeInsetsDirectional.only(end: 10.w),
              child: GestureDetector(
                onTap: () => controller.applyFilter(filter['label']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.primary : AppColor.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: isSelected ? AppColor.primary : AppColor.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (filter['icon'] != null) ...[
                        Icon(
                          filter['icon'],
                          size: 16.sp,
                          color: isSelected ? AppColor.white : AppColor.primary,
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        filter['label'].toString().tr,
                        style: TextStyle(
                          color: isSelected ? AppColor.white : AppColor.black,
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}