import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';

class DestinationField extends GetView<TripSearchController> {
  const DestinationField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isEditingDestination.value
          ? CustomTextFormField(
              hint: "Destination",
              controller: controller.destinationController,
              prefixIcon: Icons.location_on_outlined,
              suffixIcon: Icons.map_outlined,
              onSuffixPressed: () => print("Open Map"),
              onChanged: (val) => controller.destination.value = val,
              onEditingComplete: () =>
                  controller.isEditingDestination.value = false,
            )
          : Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColor.darkgreen,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DESTINATION",
                        style: TextStyle(fontSize: 10.sp, color: AppColor.grey),
                      ),
                      Text(
                        controller.destination.value,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: controller.destination.value.contains("Where")
                              ? AppColor.grey
                              : AppColor.black,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.destination.value ==
                        "Where are you going?") {
                      controller.destinationController.clear();
                    } else {
                      controller.destinationController.text =
                          controller.destination.value;
                    }
                    controller.isEditingDestination.value = true;
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18.sp,
                    color: AppColor.grey,
                  ),
                ),
              ],
            ),
    );
  }
}
