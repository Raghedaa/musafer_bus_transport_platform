import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  // دالة إرسال رمز استعادة كلمة المرور
  void sendResetCode() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // هنا يتم استدعاء الـ API لاحقاً لإرسال الرمز
        await Future.delayed(const Duration(seconds: 2));

        // الانتقال لصفحة التحقق من الرمز (يجب إنشاؤها لاحقاً)
        // Get.toNamed(AppRoutes.verifyCode, arguments: emailController.text);

        Get.snackbar(
          "success".tr,
          "resetCodeSent".tr, // أضف هذا المفتاح للترجمة
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }


  @override
  void onInit() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void resetPassword() {
    if (passwordController.text == confirmPasswordController.text) {
      print("Password Reset Successfully");
    } else {
      Get.snackbar("Error", "Passwords do not match");
    }
  }
}