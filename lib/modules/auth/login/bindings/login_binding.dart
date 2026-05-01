import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/login_controller.dart';
import '../../sign_up/controllers/signup_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<AuthProvider>(() => AuthProvider(Get.find<ApiService>()));
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<AuthProvider>()));
    Get.lazyPut<LoginController>(() => LoginController(Get.find<AuthRepository>()));
    Get.lazyPut<SignUpController>(() => SignUpController(Get.find<AuthRepository>()));
  }
}