import 'package:get/get.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/models/booking_summary_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/repositories/trip_repository.dart';
import '../../booking_summary/controllers/booking_summary_controller.dart';
import '../../booking_summary/view/screen/booking_summary_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';

class SelectSeatController extends GetxController {
  static TripModel? staticTrip;
  final TripRepository _tripRepository = TripRepository();

  var isLoading = true.obs;
  var vehicleModel = Rxn<VehicleModel>();
  var selectedSeats = <String>[].obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (staticTrip != null) {
      vehicleModel.value = VehicleModel.fromJson(staticTrip!.rawVehicle, staticTrip!.rawSeatMap);
    }
    isLoading.value = false;
  }

  Future<void> fetchSeatsData() async {
    try {
      isLoading.value = true;

      var newTripData = await _tripRepository.fetchTripDetails(staticTrip!.id);
      var newVehicle = VehicleModel.fromJson(newTripData.rawVehicle, newTripData.rawSeatMap);

      for (var seatLabel in selectedSeats.toList()) {
        final seatInNewData = newVehicle.seats.firstWhereOrNull((s) => s.label == seatLabel);

        if (seatInNewData != null && seatInNewData.status == 3) {
          selectedSeats.remove(seatLabel);
          CustomSnackBar.showError("seat_booked_by_another".trParams({'seatNumber': seatLabel}));        }
      }

      vehicleModel.value = newVehicle;
      totalPrice.value = selectedSeats.length * (staticTrip?.price ?? 0.0);

    } catch (e) {
      CustomSnackBar.showError("failed_update_seats".tr);    } finally {
      isLoading.value = false;
    }
  }
  void toggleSeat(String label) {
    if (selectedSeats.contains(label)) {
      selectedSeats.remove(label);
    } else {
      selectedSeats.add(label);
    }
    totalPrice.value = selectedSeats.length * (staticTrip?.price ?? 0.0);
  }
  String getSeatLabel(int row, int col) {
    final seat = vehicleModel.value?.seats.firstWhereOrNull(
            (s) => s.rowIndex == row && s.columnIndex == col);

    return seat?.label ?? "";
  }


  void goToPayment() {
    if (selectedSeats.isEmpty) {
      CustomSnackBar.showError("select_at_least_one".tr);
      return;
    }


    final summaryModel = BookingSummaryModel(
      tripDetails: staticTrip!,
      selectedSeats: selectedSeats.toList(),
      pnrNumber: "PENDING",
      totalPrice: totalPrice.value,
      bookingDate: DateTime.now(),
    );

    if (Get.isRegistered<BookingSummaryController>()) {
      Get.delete<BookingSummaryController>();
    }

    final summaryCtrl = Get.put(BookingSummaryController());
    summaryCtrl.bookingSummaryModel.value = summaryModel;

    Get.find<MainLayoutController>().pushToExplore(const BookingSummaryScreen());
  }
}