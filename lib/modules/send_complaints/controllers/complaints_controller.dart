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
        await Future.delayed(const Duration(seconds: 2));

        Get.back();

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

}
