import 'package:get/get.dart';

import '../../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();
  var userData = {}.obs;
  var isLoading = true.obs;

  String get userName => userData['name'] ?? "No Name";
  String get userPhone => userData['phone_number'] ?? "No Phone";

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    var data = await _repo.getProfile();
    if (data != null) userData.value = data;
    isLoading.value = false;
  }

  // void fetchData() async {
  //   isLoading.value = true;
  //   var data = await _repo.getProfile();
  //   if (data != null) userData.value = data;
  //   isLoading.value = false;
  // }
}