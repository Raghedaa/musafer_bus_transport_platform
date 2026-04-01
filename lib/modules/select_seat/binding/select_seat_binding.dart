import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controllers/select_seat_controller.dart';


class SelectSeatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectSeatController());
  }
}