import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/app_routes/app_routes.dart';

class SignUpController extends GetxController {
  late TextEditingController phoneController;

  @override
  void onInit() {
    phoneController = TextEditingController();
    super.onInit();
  }

  void sendCode() {
    if (phoneController.text.isNotEmpty) {
      Get.toNamed(AppRoute.verifyEmail);
    } else {
      Get.snackbar("Alert", "Please enter your phone number",);
    }
  }

  void signInWithGoogle() {
    print("Google Sign In Pressed");
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}