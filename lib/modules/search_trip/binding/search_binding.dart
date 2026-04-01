import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class TripSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripSearchController>(() => TripSearchController(), fenix: true);
  }
}