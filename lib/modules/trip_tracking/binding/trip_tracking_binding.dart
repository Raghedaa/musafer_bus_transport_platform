import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../data/repositories/trip_repository.dart';
import '../controllers/trip_tracking_controller.dart';

// class TripTrackingBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => BookingRepository());
//     Get.lazyPut(() => TrackingRepository());
//     Get.lazyPut(() => TripTrackingController(bookingId: Get.arguments));
//   }
// }


class TripTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingRepository());
    Get.lazyPut(() => TrackingRepository());
    Get.lazyPut(() => TripRepository());

    final args = Get.arguments as Map<String, dynamic>;
    final int id = args['tripId'] ?? args['bookingId']; // مرونة في الاسم

    // تمرير الـ ID للـ Controller
    Get.lazyPut(() => TripTrackingController(tripId: id));
  }
}