import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../controllers/complaints_controller.dart';

class CategorySelector extends GetView<ComplaintsController> {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complaint Category'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(() {
          if (controller.isCategoriesLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkgreen),
            );
          }
          if (controller.categories.isEmpty) {
            return Text(
              'No categories available'.tr,
              style: TextStyle(color: AppColor.grey, fontSize: 12.sp),
            );
          }
          return Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.categories.map((cat) {
              final isSelected =
                  controller.selectedCategory.value?.id == cat.id;
              final name = Get.locale?.languageCode == 'ar'
                  ? cat.nameAr
                  : cat.nameEn;
              return GestureDetector(
                onTap: () => controller.selectCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.darkgreen
                        : AppColor.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.darkgreen
                          : AppColor.grey.withOpacity(0.25),
                    ),
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                      isSelected ? Colors.white : AppColor.black,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}