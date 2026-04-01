import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../shared/custom_button.dart';
import '../shared/custom_text_form_field.dart';


// core/utils/app_pickers.dart
class AppPickers {

  static Future<DateTime?> showCustomDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColor.darkgreen),
          ),
          child: child!,
        );
      },    );
  }

  static void showPassengerPicker({
    required BuildContext context,
    required TextEditingController customController,
    required Function(String) onSelected,
  }) {
    Get.bottomSheet(
      Container(
        height: 300.h,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Number of Passengers :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: List.generate(5, (index) {
                  int num = index + 1;
                  return ActionChip(
                    label: Text("$num Adult"),
                    onPressed: () {
                      onSelected("$num Adult");
                      Get.back();
                    },
                  );
                }),
              ),
              const Divider(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: customController,
                      keyboardType: TextInputType.number,
                      hint: "E.g. 10",
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Confirm",
                    width: 100.w,
                    height: 55.h,
                    onPressed: () {
                      if (customController.text.isNotEmpty) {
                        onSelected("${customController.text} Adults");
                        customController.clear();
                        Get.back();
                      }
                    },

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
