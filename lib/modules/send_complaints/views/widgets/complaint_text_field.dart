import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/shared/custom_text_form_field.dart';

class ComplaintTextField extends StatelessWidget {
  final TextEditingController controller;

  const ComplaintTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hint: "writeYourComplaint".tr,
      maxLines: 8, // هنا نحدد عدد الأسطر ليصبح الحقل كبيراً
      keyboardType: TextInputType.multiline, // لدعم الانتقال لسطر جديد عند الكتابة
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please write something first".tr;
        }
        return null;
      },
    );
  }
}