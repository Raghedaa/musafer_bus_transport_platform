import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';

import '../../../../../data/models/city_model.dart';

class DestinationField extends GetView<TripSearchController> {
  const DestinationField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCitiesLoading.value) return const SizedBox.shrink();

      return CustomTextFormField<CityModel>(
        hint: controller.isCitiesLoading.value ? "Loading...".tr : "Destination".tr,
        // hint: "Destination".tr,
        prefixIcon: Icon(Icons.location_on_outlined, color: AppColor.primary, size: 22.sp),
        isExpanded: true,
        dropdownValue: controller.selectedDestinationCity.value,
        initialDropdownHint: "Where are you going?".tr,
        dropdownItems: controller.cities.map((city) {
          return DropdownMenuItem<CityModel>(
            value: city,
            child: Text(city.name.tr, style: TextStyle(fontSize: 15.sp, color: AppColor.black)),
          );
        }).toList(),
        onDropdownChanged: (city) {
          if (city != null) controller.selectedDestinationCity.value = city;
        },
      );
    });
  }
}