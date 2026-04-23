import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../shared/custom_button.dart';
import '../shared/custom_text_form_field.dart';

class AppPickers {

  static Future<DateTime?> showCustomDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        final isDark = Get.isDarkMode;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: AppColor.primary,
              onPrimary: Colors.white,
              secondary: AppColor.primary,
              onSecondary: Colors.white,
              surface: AppColor.cardColor,
              onSurface: AppColor.black,
              background: AppColor.background,
              onBackground: AppColor.black,
              error: AppColor.red,
              onError: AppColor.white,
            ),

            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColor.primary,
              selectionColor: AppColor.primary.withOpacity(0.3),
              selectionHandleColor: AppColor.primary,
            ),

            dialogBackgroundColor: AppColor.cardColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
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
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text("Select Number of Passengers :".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: List.generate(5, (index) {
                  int num = index + 1;
                  return ActionChip(
                    label: Text("$num Adult".tr),
                    onPressed: () {
                      onSelected("$num Adult".tr);
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
                      hint: "E.g. 10".tr,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: "Confirm".tr,
                    width: 100.w,
                    height: 55.h,
                    onPressed: () {
                      if (customController.text.isNotEmpty) {
                        onSelected("${customController.text} Adults".tr);
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
