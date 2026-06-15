import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musafer/data/repositories/trip_repository.dart';
import 'package:musafer/modules/profile/controller/profile_controller.dart';
import '../../../core/services/api_service.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/models/city_model.dart';
import '../../../data/repositories/profile_repository.dart';

// class PersonalInfoController extends GetxController {
//   final ProfileRepository _repo = ProfileRepository();
//   final TripRepository tripRepository = TripRepository();
//   final ProfileController _profileController = Get.find<ProfileController>();
//   final Box _box = Hive.box('user_box');
//
//   var isLoading = true.obs;
//   var cities = <CityModel>[].obs;
//   Rxn<CityModel> selectedCity = Rxn<CityModel>();
//
//   late TextEditingController nameController;
//   late TextEditingController usernameController;
//   late TextEditingController phoneController;
//   late TextEditingController genderController;
//   late TextEditingController emailController;
//   late TextEditingController addressController;
//
//   RxString imagePath = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     tripRepository.fetchCities().then((list) {
//       cities.assignAll(list);
//       var currentCityName = _profileController.userData['city'];
//       if (currentCityName != null) {
//         selectedCity.value = cities.firstWhereOrNull(
//               (c) => c.name == currentCityName,
//         );
//       }
//     });
//
//     final user = _profileController.userData;
//
//     nameController = TextEditingController(text: user['name'] ?? '');
//     usernameController = TextEditingController(text: user['username'] ?? '');
//     phoneController = TextEditingController(text: user['phone_number'] ?? '');
//     genderController = TextEditingController(text: user['gender'] ?? '');
//     emailController = TextEditingController(text: user['email'] ?? '');
//     addressController = TextEditingController(text: user['address'] ?? '');
//
//     imagePath.value = _box.get('profile_image', defaultValue: '');
//
//     var currentCityId = _profileController.userData['city_id'];
//     if (currentCityId != null) {
//       selectedCity.value = cities.firstWhereOrNull((c) => c.id == currentCityId);
//     }
//
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     usernameController.dispose();
//     phoneController.dispose();
//     genderController.dispose();
//     emailController.dispose();
//     addressController.dispose();
//     super.onClose();
//   }
//
//
//   void pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       imagePath.value = picked.path;
//       _box.put('profile_image', picked.path);
//     }
//   }
//
//
//   void saveChanges() async {
//     bool isConnected = await ApiService().checkConnection();
//     if (!isConnected) {
//       // Get.snackbar("Error", "No internet connection.");
//       return;
//     }
//
//     Map<String, dynamic> updateData = {
//       "name": nameController.text,
//       "username": usernameController.text,
//       "email": emailController.text.isNotEmpty ? emailController.text : null,
//       "phone_number": phoneController.text,
//       "gender": genderController.text,
//       "address": addressController.text.isEmpty ? null : addressController.text,
//       "city": selectedCity.value?.name,
//     };
//
//     print("Sending to API: $updateData");
//
//     var result = await _repo.updateProfile(updateData);
//
//     if (result != null && result is Map) {
//       _profileController.userData.value = Map<String, dynamic>.from(result);
//       Get.back();
//       CustomSnackBar.showSuccess("Profile Updated Successfully");
//     } else {
//       CustomSnackBar.showError("Failed to update profile.");
//       // Get.snackbar("Error", "Failed to update profile.");
//     }
//   }
//
//
// }




class PersonalInfoController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();
  final TripRepository tripRepository = TripRepository();
  final ProfileController _profileController = Get.find<ProfileController>();
  final Box _box = Hive.box('user_box');

  var isLoading = true.obs;
  var cities = <CityModel>[].obs;
  Rxn<CityModel> selectedCity = Rxn<CityModel>();

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
    loadInitialData();
  }

  // أضف هذه الدالة هنا
  void pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imagePath.value = picked.path;
      _box.put('profile_image', picked.path);
    }
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      final list = await tripRepository.fetchCities();
      cities.assignAll(list);

      final user = _profileController.userData;
      nameController = TextEditingController(text: user['name'] ?? '');
      usernameController = TextEditingController(text: user['username'] ?? '');
      phoneController = TextEditingController(text: user['phone_number'] ?? '');
      genderController = TextEditingController(text: user['gender'] ?? '');
      emailController = TextEditingController(text: user['email'] ?? '');
      addressController = TextEditingController(text: user['address'] ?? '');

      var currentCityName = user['city'];
      if (currentCityName != null) {
        selectedCity.value = cities.firstWhereOrNull((c) => c.name == currentCityName);
      }

      imagePath.value = _box.get('profile_image', defaultValue: '');
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void saveChanges() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> updateData = {
        "name": nameController.text,
        "username": usernameController.text,
        "email": emailController.text.isNotEmpty ? emailController.text : null,
        "phone_number": phoneController.text,
        "gender": genderController.text,
        "address": addressController.text.isEmpty ? null : addressController.text,
        "city": selectedCity.value?.name,
      };

      var result = await _repo.updateProfile(updateData);
      if (result != null) {
        _profileController.userData.value = Map<String, dynamic>.from(result);
        Get.back();
        CustomSnackBar.showSuccess("تم تحديث الملف الشخصي بنجاح");
      }
    } catch (e) {
      CustomSnackBar.showError("فشل تحديث البيانات");
    } finally {
      isLoading.value = false;
    }
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