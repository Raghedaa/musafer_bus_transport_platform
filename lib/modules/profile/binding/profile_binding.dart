import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // يقوم بإنشاء الكنترولر فقط عند الحاجة إليه (Lazy)
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}