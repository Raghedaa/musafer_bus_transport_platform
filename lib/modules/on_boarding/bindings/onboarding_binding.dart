import 'package:get/get.dart';
import 'package:musafer/modules/on_boarding/controllers/on_boarding_controller.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardingControllerImp>(() => OnBoardingControllerImp());
  }
}