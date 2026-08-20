import 'package:get/get.dart';
import '../controllers/complaints_controller.dart';
import '../controllers/my_complaints_controller.dart';

class ComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintsController>(() => ComplaintsController());
    Get.lazyPut<MyComplaintsController>(() => MyComplaintsController());
  }
}