import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../controllers/login_controller.dart';

class LoginFooter extends GetView<LoginController> {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLogin.value
          ? Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New traveler? ".tr, style: TextStyle(color: AppColor.primaryGrey)),
              TextButton(
                onPressed: () {
                  controller.isLogin.value = false;
                },
                child: Text(
                  "Create an account".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      )
          : const SizedBox.shrink();
    });
  }
}