import 'package:get/get.dart';

import '../../../data/models/booking_summary_model.dart';
import '../../../data/models/trip_result_model.dart';
import '../../booking_summary/controllers/booking_summary_controller.dart';
import '../../booking_summary/view/screen/booking_summary_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';

class SelectSeatController extends GetxController {
  static TripResultModel? staticTrip;

  TripResultModel? selectedTrip;
  var selectedSeats = <String>[].obs;
  var totalPrice = 0.0.obs;

  final Map<String, int> seatStatus = {
    "1A": 0,
    "1B": 0,
    "1C": 0,
    "1D": 1,
    "2A": 0,
    "2B": 0,
    "2C": 0,
    "2D": 0,
    "3A": 2,
    "3B": 1,
    "3C": 0,
    "3D": 0,
    "4A": 0,
    "4B": 0,
    "4C": 3,
    "4D": 0,
    "5A": 0,
    "5B": 0,
    "5C": 3,
    "5D": 0,
    "6A": 2,
    "6B": 0,
    "6C": 3,
    "6D": 2,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTrip = staticTrip;

    if (selectedTrip != null) {
      print(
        "Success: Trip data loaded in Controller: ${selectedTrip!.companyName}",
      );
      _updatePrice();
    } else {
      print("Warning: Trip data is still NULL in onInit");
    }
  }

  void toggleSeat(String seatNumber) {
    if (seatStatus[seatNumber] == 0) {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
      _updatePrice();
      selectedSeats.refresh();
    }
  }

  void _updatePrice() {
    if (selectedTrip != null) {
      totalPrice.value = selectedSeats.length * selectedTrip!.price;
    }
  }

  void goToPayment() {
    try {
      if (selectedTrip == null) {
        Get.snackbar("Error", "Trip data is missing".tr);
        return;
      }

      if (selectedSeats.isEmpty) {
        Get.snackbar("Notice", "Please select at least one seat".tr);
        return;
      }

      final bookingData = BookingSummaryModel(
        tripDetails: selectedTrip!,
        selectedSeats: List<String>.from(selectedSeats),
        pnrNumber: "BUS-8829-XP",
        totalPrice: totalPrice.value,
        bookingDate: DateTime.now(),
      );

      // Get.to(
      //   () => const BookingSummaryScreen(),
      //   arguments: bookingData,
      //   binding: BindingsBuilder(() {
      //     Get.put(BookingSummaryController());
      //   }),
      // );
      final summaryController = Get.put(BookingSummaryController());
      summaryController.bookingSummaryModel.value = bookingData;
      Get.find<MainLayoutController>().pushToExplore(const BookingSummaryScreen());

    }catch (e) {
      print("Error in goToPayment: $e");
    }
  }
}
