// lib/modules/complaints/controllers/complaints_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintsController extends GetxController {
  late TextEditingController tripNumberController;
  late TextEditingController ticketNumberController;
  late TextEditingController complaintController;
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    tripNumberController = TextEditingController();
    ticketNumberController = TextEditingController();
    complaintController = TextEditingController();
    super.onInit();
  }

  void sendComplaint() async {

    if (formKey.currentState!.validate()) {

      isLoading.value = true;



      try {

        // محاكاة إرسال البيانات للسيرفر (2 ثانية)

        await Future.delayed(const Duration(seconds: 2));



        Get.back(); // العودة لصفحة الإعدادات

        Get.snackbar(

          "success".tr,

          "complaintSentSuccess".tr,

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
  void onClose() {
    tripNumberController.dispose();
    ticketNumberController.dispose();
    complaintController.dispose();
    super.onClose();
  }

// دالة الإرسال...
}