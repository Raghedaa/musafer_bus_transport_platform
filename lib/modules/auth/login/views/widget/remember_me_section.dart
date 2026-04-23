import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../controllers/login_controller.dart';

class RememberMeSection extends GetView<LoginController> {
  const RememberMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          SizedBox(
            height: 24.w,
            width: 24.w,
            child: Checkbox(
              value: controller.rememberMe.value,
              onChanged: (val) => controller.toggleRememberMe(val),
              activeColor: AppColor.darkgreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => controller.toggleRememberMe(!controller.rememberMe.value),
            child: Text(
              "Remember me".tr,
              style: TextStyle(fontSize: 13.sp, color: AppColor.primaryGrey),
            ),
          ),
        ],
      ),
    );
  }
}