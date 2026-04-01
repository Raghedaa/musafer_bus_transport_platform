import 'package:get/get.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../controller/main_layout_controller.dart';
import '../../trip_results/controllers/trip_results_controller.dart';
import '../../search_trip/controllers/search_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainLayoutController());
    Get.lazyPut(() => TripSearchController()); // حقن كنترولر البحث
    Get.lazyPut(() => TripResultsController()); // حقن كنترولر النتائج ليكون جاهزاً دوماً
    Get.lazyPut(() => BookingHistoryController());
  }
}