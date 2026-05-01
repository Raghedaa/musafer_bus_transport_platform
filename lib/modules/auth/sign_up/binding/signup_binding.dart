import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {

// داخل SignUpBinding
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => AuthProvider(Get.find<ApiService>())); // تأكدي من إضافة السطر هاد
    Get.lazyPut(() => AuthRepository(Get.find<AuthProvider>())); // وتغيير هاد لياخد الـ Provider
    Get.lazyPut(() => SignUpController(Get.find<AuthRepository>()));
  }
}