import 'package:get/get.dart';
import '../controllers/ticket_controller.dart';

class TicketDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketController>(() => TicketController(), fenix: true);
  }
}