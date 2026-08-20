import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../data/repositories/trip_repository.dart';
import '../controllers/trip_tracking_controller.dart';

class TripTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingRepository(), fenix: true);
    Get.lazyPut(() => TrackingRepository(), fenix: true);
    Get.lazyPut(() => TripRepository(), fenix: true);

    final args = Get.arguments as Map<String, dynamic>;
    final int id = args['tripId'] ?? args['bookingId'];

    Get.lazyPut(() => TripTrackingController(tripId: id), fenix: true);
  }
}