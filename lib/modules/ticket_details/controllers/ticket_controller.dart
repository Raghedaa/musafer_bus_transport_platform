import 'package:get/get.dart';
import 'package:musafer/core/utils/ticket_pdf_helper.dart'; // استيراد المساعد
import 'package:open_filex/open_filex.dart';

import '../../../data/models/booking_summary_model.dart';
import '../../trip_results/controllers/trip_results_controller.dart';


class TicketController extends GetxController {
  dynamic ticketData;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      ticketData = Get.arguments ?? Get.parameters;
    }
    update();
  }

  String get pnr => (ticketData is BookingSummaryModel)
      ? ticketData.pnrNumber
      : (ticketData is Map ? (ticketData['pnrNumber'] ?? "---") : "---");


  Future<void> downloadTicket() async {
    final data = ticketData as BookingSummaryModel;

    final tripController = Get.find<TripResultsController>();
    final travelDate = tripController.travelDate.value;

    if (ticketData is! BookingSummaryModel) return;

    try {
      final file = await TicketPdfHelper.generateTicket(
        pnr: pnr,
        passengerName: "Mays Al-Zoubi",
        seat: data.selectedSeats.join(", "),
        fromCity: data.tripDetails.departureTerminal ?? "N/A",
        toCity: data.tripDetails.arrivalTerminal ?? "N/A",
        departureTime: data.tripDetails.departureTime ?? "00:00",
        departureDate: travelDate,
      );
      await OpenFilex.open(file.path);
    } catch (e) {
      Get.snackbar("Error", "Could not generate PDF:".tr+ "$e");
    }
  }
}