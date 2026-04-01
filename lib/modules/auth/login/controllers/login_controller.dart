import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';

class LoginController extends GetxController {

  late TextEditingController emailController;
  late TextEditingController passwordController;
  var isPasswordHidden = true.obs;
  var rememberMe = true.obs;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() {
    // Get.toNamed(AppRoute.home);
    print("Email: ${emailController.text}");
  }
}