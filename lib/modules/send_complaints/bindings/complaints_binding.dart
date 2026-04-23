// lib/modules/send_complaints/bindings/complaints_binding.dart
import 'package:get/get.dart';
import '../controllers/complaints_controller.dart';

class ComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintsController>(() => ComplaintsController());
  }
}