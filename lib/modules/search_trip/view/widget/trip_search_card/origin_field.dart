import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';

class OriginField extends GetView<TripSearchController> {
  const OriginField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isEditingOrigin.value
        ? CustomTextFormField(
      hint: "Origin",
      controller: controller.originController,
      prefixIcon: Icons.radio_button_checked,
      suffixIcon: Icons.map_outlined,
      onSuffixPressed: () => print("Open Map"),
      onChanged: (val) => controller.origin.value = val,
      onEditingComplete: () => controller.isEditingOrigin.value = false,
    )
        : Row(
      children: [
        Icon(Icons.radio_button_checked, color: AppColor.darkgreen, size: 22.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ORIGIN", style: TextStyle(fontSize: 10.sp, color: AppColor.grey)),
              Text(controller.origin.value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if (controller.origin.value == "Cairo, Egypt") {
              controller.originController.clear();
            } else {
              controller.originController.text = controller.origin.value;
            }
            controller.isEditingOrigin.value = true;
          },          icon: Icon(Icons.edit_outlined, size: 18.sp, color: AppColor.grey),
        )
      ],
    ));
  }
}