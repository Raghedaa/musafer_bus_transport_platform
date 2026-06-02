import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';

import '../../../../../data/models/city_model.dart';

class OriginField extends GetView<TripSearchController> {
  const OriginField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCitiesLoading.value) {
        return  Center(child: LinearProgressIndicator( backgroundColor: AppColor.grey.withOpacity(0.3),color: AppColor.darkgreen,  ));
      }

      return CustomTextFormField<CityModel>(
        hint: controller.isCitiesLoading.value ? "Loading...".tr : "Origin".tr,
        // hint: "Origin".tr,
        prefixIcon: Icon(Icons.radio_button_checked, color: AppColor.primary, size: 22.sp),
        isExpanded: true,
        dropdownValue: controller.selectedOriginCity.value,
        initialDropdownHint: "Select Origin".tr,
        dropdownItems: controller.cities.map((city) {
          return DropdownMenuItem<CityModel>(
            value: city,
            child: Text(city.name.tr, style: TextStyle(fontSize: 15.sp, color: AppColor.black)),
          );
        }).toList(),
        onDropdownChanged: (city) {
          if (city != null) controller.selectedOriginCity.value = city;
        },
      );
    });
  }
}