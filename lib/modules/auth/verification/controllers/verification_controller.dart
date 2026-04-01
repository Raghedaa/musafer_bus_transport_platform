import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VerificationController extends GetxController {
  var currentStep = 0.obs;

  late TextEditingController fullNameController;
  String? selectedGender;

  @override
  void onInit() {
    fullNameController = TextEditingController();
    super.onInit();
  }

  void onOtpCompleted(String code) {
    if (code.length == 4) {
      Future.delayed(const Duration(milliseconds: 300), () {
        nextStep();
      });
    }
  }

  void setGender(String gender) {
    selectedGender = gender;
    update();
  }

  void nextStep() {
    if (currentStep.value < 1) {
      currentStep.value++;
    } else {
      submit();
    }
  }

  void submit() {
    print("Final Submit: ${fullNameController.text}, Gender: $selectedGender");
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }
}