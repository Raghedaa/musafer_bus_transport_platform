import 'package:get/get.dart';

class ProfileController extends GetxController {
  void logout() {
    Get.offAllNamed('/login');
  }
}