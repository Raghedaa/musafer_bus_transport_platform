import 'package:get/get.dart';
import 'package:musafer/data/models/trip_result_model.dart';
import '../../select_seat/controllers/select_seat_controller.dart';

class TripDetailsController extends GetxController {
  late TripResultModel trip;

  @override
  void onInit() {
    super.onInit();
    // تأكد أنك تستخدم السطر الصحيح للوصول للبيانات الساكنة
    if (SelectSeatController.staticTrip != null) {
      trip = SelectSeatController.staticTrip!;
    } else {
      print("Error: No trip data found in static memory!");
    }
  }
}