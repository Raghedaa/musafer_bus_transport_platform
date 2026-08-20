
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/shared/custom_snackbar.dart';
import '../../../core/utils/ticket_pdf_helper.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/trip_repository.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../main_layout/controller/main_layout_controller.dart';

class TicketController extends GetxController {
  final TripRepository _tripRepository = TripRepository();
  final BookingRepository _bookingRepository = BookingRepository();

  Map<String, dynamic>? ticketData;
  TripModel? tripDetails;

  var isCancelling = false.obs;
  List<String>? _localUpdatedSeats;

  String get pnr => ticketData?['pnr_code'] ?? "";

  String get title {
    return (Get.locale?.languageCode == 'ar')
        ? "تذكرة سفر"
        : "Travel Ticket";
  }

  void updateSeatsLocally(List<String> seats) {
    final cleanSeats = seats
        .map((seat) => seat.toString().trim())
        .where((seat) => seat.isNotEmpty)
        .toList();

    _localUpdatedSeats = List<String>.from(cleanSeats);

    if (ticketData != null) {
      ticketData!['seat_numbers'] = List<String>.from(cleanSeats);
    }

    update();

    print("🎫 Ticket seats updated locally: $cleanSeats");
  }

  Future<void> refreshTicketDetails() async {
    if (ticketData == null) return;

    try {
      final bookingId = ticketData!['id'];

      final updatedData =
      await _bookingRepository.fetchBookingDetails(bookingId);

      await setTripData(updatedData);

      if (_localUpdatedSeats != null && ticketData != null) {
        ticketData!['seat_numbers'] =
        List<String>.from(_localUpdatedSeats!);
      }

      update();
    } catch (e) {
      print("📴 لا يوجد اتصال — نستخدم بيانات التذكرة الحالية");

      if (_localUpdatedSeats != null && ticketData != null) {
        ticketData!['seat_numbers'] =
        List<String>.from(_localUpdatedSeats!);
      }

      update();
    }
  }

  String getQrData() {
    return pnr;
  }

  Future<void> setTripData(dynamic bookingResponse) async {
    if (bookingResponse is! Map<String, dynamic>) return;

    ticketData = Map<String, dynamic>.from(bookingResponse);

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
    final bookingId = bookingResponse['id'];

    if (tripId != null) {
      try {
        final freshTrip = await _tripRepository.fetchTripDetails(tripId);
        tripDetails = freshTrip;
        update();
      } catch (e) {
        print("Could not refresh trip details: $e");
      }


    }

    if (_localUpdatedSeats != null && ticketData != null) {
      ticketData!['seat_numbers'] = List<String>.from(_localUpdatedSeats!);
    }

    update();
  }

  Future<void> forceRefreshFromServer() async {
    if (ticketData == null) return;

    try {
      final bookingId = ticketData!['id'];

      final response = await _bookingRepository.provider.getBookingDetails(bookingId);

      if (response.statusCode == 200) {
        final freshData = response.data['data'];
        await setTripData(freshData);
        update();
        print('✅ Force refreshed ticket data from server');
      }
    } catch (e) {
      print('Error force refreshing: $e');
    }
  }

  Future<void> downloadTicket() async {
    if (ticketData == null || tripDetails == null) {
      Get.snackbar(
        "Error",
        "Ticket data is missing",
      );
      return;
    }

    try {
      final file = await TicketPdfHelper.generateTicket(
        data: ticketData!,
        trip: tripDetails!,
      );

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        Get.snackbar(
          "Error",
          "Could not open file: ${result.message}",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "PDF Error: $e",
      );
    }
  }

  Future<void> cancelBooking() async {
    if (ticketData == null || ticketData!['id'] == null) return;

    final bookingId = int.parse(ticketData!['id'].toString());
    isCancelling.value = true;

    try {
      final bookingRepository = BookingRepository();
      await bookingRepository.cancelBooking(bookingId);

      await bookingRepository.clearBookingCache();

      CustomSnackBar.showSuccess("booking_cancelled_successfully");

      if (Get.isRegistered<BookingHistoryController>()) {
        final historyCtrl = Get.find<BookingHistoryController>();
        historyCtrl.removeBookingPermanently(bookingId);
      }

      final layoutController = Get.find<MainLayoutController>();
      if (layoutController.bookingStack.length > 1) {
        layoutController.bookingStack.removeLast();
      }

    } catch (e) {
      CustomSnackBar.showError("فشل إلغاء الحجز");
    } finally {
      isCancelling.value = false;
    }
  }

  Future<List<String>> getAllMergedSeatsForTrip(int tripId) async {
    try {
      final seats = await _bookingRepository.fetchAllMergedSeatsForTrip(tripId);
      return seats;
    } catch (e) {
      print('Error getting all merged seats: $e');
      return [];
    }
  }

  Future<List<String>> getLatestConfirmedSeatsForTrip(int tripId) async {
    try {
      final seats = await _bookingRepository.fetchLatestConfirmedSeatsForTrip(tripId);
      return seats;
    } catch (e) {
      print('Error getting latest confirmed seats: $e');
      return [];
    }
  }

  Future<TripModel> fetchFreshTripData(int tripId) async {
    try {
      final tripData = await _tripRepository.fetchTripDetails(tripId);

      if (tripData.rawVehicle.isNotEmpty && tripData.rawSeatMap.isNotEmpty) {
        tripDetails = tripData;
        update();
      }

      return tripData;
    } catch (e) {
      print('Error fetching fresh trip data: $e');
      rethrow;
    }
  }
}