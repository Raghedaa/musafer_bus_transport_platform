import 'package:get/get.dart';
import '../../my_subscriptions/controllers/my_subscriptions_controller.dart';
import '../controllers/booking_summary_controller.dart';

class BookingSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingSummaryController>(() => BookingSummaryController());

    Get.lazyPut<MySubscriptionsController>(() => MySubscriptionsController());
  }
}