import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';

import '../../controllers/login_controller.dart';

class AuthToggle extends GetView<LoginController> {
  const AuthToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: AppColor.fillColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          _buildBtn("Login".tr, controller.isLogin.value, () => controller.isLogin.value = true),
          _buildBtn("SignUp".tr, !controller.isLogin.value, () => controller.isLogin.value = false),
        ],
      ),
    ));
  }

  Widget _buildBtn(String title, bool active, VoidCallback tap) {
    return Expanded(
      child: GestureDetector(
        onTap: tap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: active ? AppColor.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: active ? [BoxShadow(color: Colors.black12, blurRadius: 4.r)] : [],
          ),
          child: Center(child: Text(title, style:  TextStyle(fontWeight: FontWeight.bold,color:AppColor.black ))),
        ),
      ),
    );
  }
}