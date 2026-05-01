import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_routes/app_routes.dart';

class ProfileController extends GetxController {
  final GetStorage _storage = GetStorage();

  var userName = "".obs;
  var userPhone = "".obs;
  RxString imagePath = ''.obs;


  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    print("------- Storage Check -------");
    print("All Keys in Storage: ${_storage.getKeys()}");

    var userData = _storage.read("user_info");
    print("User Info Data: $userData");

    if (userData != null) {
      userName.value = userData['name'] ?? "No Name";
      userPhone.value = userData['phone_number'] ?? "No Phone";
    }

    imagePath.value = _storage.read("profile_image") ?? '';

  }

  void logout() {
    final box = GetStorage();
    box.remove('token');
    box.remove('user_info');
    Get.offAllNamed(AppRoute.login);
  }
}