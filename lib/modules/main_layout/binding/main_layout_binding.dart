import 'package:get/get.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../booking_summary/controllers/booking_summary_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../select_seat/controllers/select_seat_controller.dart';
import '../../subscription/controllers/subscription_controller.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../controller/main_layout_controller.dart';
import '../../trip_results/controllers/trip_results_controller.dart';
import '../../search_trip/controllers/search_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainLayoutController());
    Get.lazyPut(() => TripSearchController());
    Get.lazyPut(() => TripResultsController());
    Get.lazyPut(() => BookingHistoryController());
    Get.lazyPut(() => SubscriptionController());
    Get.lazyPut(() => SelectSeatController());
    Get.lazyPut(() => BookingSummaryController());
    Get.lazyPut(() => TicketController());
    Get.lazyPut(() => ProfileController());
  }
}