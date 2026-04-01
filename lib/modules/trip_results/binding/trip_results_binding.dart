import 'package:get/get.dart';
import '../controllers/trip_results_controller.dart';

class TripResultsBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<TripResultsController>(() => TripResultsController());
  }
}