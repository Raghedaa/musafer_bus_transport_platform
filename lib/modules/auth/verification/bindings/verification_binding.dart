import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../controllers/verification_controller.dart';

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    // حقن الخدمات بالترتيب الصحيح
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => AuthProvider(Get.find<ApiService>()));
    Get.lazyPut(() => AuthRepository(Get.find<AuthProvider>()));

    // حقن الكنترولر مع تمرير الريبوزتري له
    Get.lazyPut(() => VerificationController(Get.find<AuthRepository>()));
  }
}