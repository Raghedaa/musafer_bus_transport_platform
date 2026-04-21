import 'package:get/get.dart';
import 'package:musafer/modules/trip_details/controllers/trip_details_controller.dart';

class TripDetailsBinding  extends Bindings {
  @override
  void dependencies() {
    // يقوم بإنشاء الكنترولر فقط عند الحاجة إليه (Lazy)
    Get.lazyPut<TripDetailsController>(() => TripDetailsController());
  }
}