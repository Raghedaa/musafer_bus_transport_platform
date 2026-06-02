import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import '../../../core/utils/ticket_pdf_helper.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/trip_repository.dart';

class TicketController extends GetxController {
  final TripRepository _tripRepository = TripRepository();
  final BookingRepository _bookingRepository = BookingRepository();

  Map<String, dynamic>? ticketData;
  TripModel? tripDetails;

  String get pnr => ticketData?['pnr_code'] ?? "";
  String get title => (Get.locale?.languageCode == 'ar') ? "تذكرة سفر" : "Travel Ticket";


  Future<void> refreshTicketDetails() async {
    if (ticketData == null) return;

    try {
      final bookingId = ticketData!['id'];
      final updatedData = await _bookingRepository.fetchBookingDetails(bookingId);
      await setTripData(updatedData);
      update();
    } catch (e) {
      print("📴 بلا نت — التفاصيل محملة من الكاش");
      // ما نعرض error لأن البيانات موجودة من الكاش
      update();
    }
  }



  String getQrData() {
    return pnr;
  }

  Future<void> setTripData(dynamic bookingResponse) async {
    if (bookingResponse is Map<String, dynamic>) {
      ticketData = bookingResponse;

      if (bookingResponse['trip'] != null) {
        try {
          final tripMap = Map<String, dynamic>.from(bookingResponse['trip']);
          tripDetails = TripModel.fromJson(tripMap);
          update();
        } catch (e) {
          print("Error parsing trip from booking: $e");
        }
      }

      final tripId = bookingResponse['trip_id'] ?? bookingResponse['trip']?['id'];
      if (tripId != null) {
        try {
          final freshTrip = await _tripRepository.fetchTripDetails(tripId);
          tripDetails = freshTrip;
          update();
        } catch (e) {

        }
      }

      update();
    }
  }

  Future<void> downloadTicket() async {
    if (ticketData == null || tripDetails == null) {
      Get.snackbar("Error", "Ticket data is missing");
      return;
    }

    try {
      final file = await TicketPdfHelper.generateTicket(
        data: ticketData!,
        trip: tripDetails!,
      );

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        Get.snackbar("Error", "Could not open file: ${result.message}");
      }
    } catch (e) {
      Get.snackbar("Error", "PDF Error: $e");
    }
  }
}