import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoController extends GetxController {
  final box = GetStorage();

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  RxString imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final user = box.read('user_info') ?? {};

    nameController = TextEditingController(text: user['name'] ?? '');
    usernameController = TextEditingController(text: user['username'] ?? '');
    phoneController = TextEditingController(text: user['phone_number'] ?? '');
    genderController = TextEditingController(text: user['gender'] ?? '');
    emailController = TextEditingController(text: user['email'] ?? '');
    addressController = TextEditingController(text: user['address'] ?? '');

    imagePath.value = box.read('profile_image') ?? '';
  }

  void pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imagePath.value = picked.path;
      box.write('profile_image', picked.path);
    }
  }

  void saveChanges() {
    final updatedUser = {
      "name": nameController.text,
      "username": usernameController.text,
      "phone_number": phoneController.text,
      "gender": genderController.text,
      "email": emailController.text,
      "address": addressController.text,
    };

    box.write("user_info", updatedUser);

    Get.snackbar("Success", "Profile updated successfully");
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}