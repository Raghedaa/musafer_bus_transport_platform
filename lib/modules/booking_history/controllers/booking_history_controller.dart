// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/app_color.dart';
// import '../../../core/services/api_service.dart';
// import '../../../core/shared/custom_snackbar.dart';
// import '../../../data/models/booking_history_model.dart';
// import '../../../data/repositories/booking_repository.dart';
// import '../../../routes/app_routes/app_routes.dart';
// import '../../main_layout/controller/main_layout_controller.dart';
// import '../../ticket_details/controllers/ticket_controller.dart';
// import '../../ticket_details/view/screen/ticket_details_screen.dart';
// import '../../trip_tracking/controllers/trip_tracking_controller.dart';
// import '../../trip_tracking/view/screen/trip_tracking_screen.dart';
//
// class BookingHistoryController extends GetxController with WidgetsBindingObserver {
//   var isLoading = true.obs;
//   var allBookings = <BookingHistoryModel>[].obs;
//   var filteredBookings = <BookingHistoryModel>[].obs;
//   var selectedFilter = "All".obs;
//   var highlightedBookingId = Rxn<int>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//     fetchBookings();
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.onClose();
//   }
//
//   void setHighlightedId(int id) {
//     highlightedBookingId.value = id;
//     print("🟢 Highlighted ID updated to: $id");
//
//     Future.delayed(const Duration(seconds: 1), () {
//       if (highlightedBookingId.value == id) {
//         clearHighlight();
//         print("⏱️ Highlight cleared automatically.");
//       }
//     });
//   }
//
//   void clearHighlight() {
//     highlightedBookingId.value = null;
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       fetchBookings();
//     }
//   }
//
//   List<BookingHistoryModel> _mergeBookings(List<BookingHistoryModel> bookings) {
//     final Map<int, BookingHistoryModel> mergedMap = {};
//     final List<BookingHistoryModel> cancelledBookings = [];
//
//     for (var booking in bookings) {
//       if (booking.status.toLowerCase() == 'cancelled') {
//         cancelledBookings.add(booking);
//         continue;
//       }
//
//       final key = booking.tripId;
//
//       if (mergedMap.containsKey(key)) {
//         final existing = mergedMap[key]!;
//
//         final allSeats = <String>[];
//         if (existing.seatNumbers != null) {
//           allSeats.addAll(existing.seatNumbers!);
//         }
//         if (booking.seatNumbers != null) {
//           allSeats.addAll(booking.seatNumbers!);
//         }
//
//         final uniqueSeats = allSeats.toSet().toList();
//
//         existing.seatNumbers = uniqueSeats;
//
//         if (booking.status.toLowerCase() == 'confirmed' &&
//             existing.status.toLowerCase() != 'confirmed') {
//           existing.status = booking.status;
//         }
//
//         if (booking.pnr != existing.pnr && existing.pnr == '---') {
//           existing.pnr = booking.pnr;
//         }
//
//         if (booking.rawTrip != null) {
//           existing.rawTrip = booking.rawTrip;
//         }
//
//         if (booking.createdAt.isAfter(existing.createdAt)) {
//           existing.createdAt = booking.createdAt;
//         }
//       } else {
//         mergedMap[key] = booking.copyWith(
//           seatNumbers: List<String>.from(booking.seatNumbers ?? []),
//         );
//       }
//     }
//
//     final result = mergedMap.values.toList();
//     result.addAll(cancelledBookings);
//
//     result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//
//     return result;
//   }
//
//   Future<void> fetchBookings() async {
//     try {
//       isLoading.value = true;
//       final BookingRepository _repository = BookingRepository();
//       final bookings = await _repository.fetchBookingHistory();
//
//       final mergedBookings = _mergeBookings(bookings);
//       allBookings.assignAll(mergedBookings);
//
//       changeFilter(selectedFilter.value);
//
//       print("🟢 Total bookings: ${bookings.length}");
//       print("🟢 Merged bookings: ${allBookings.length}");
//       print("🟢 Merged booking IDs: ${allBookings.map((b) => b.id).toList()}");
//       print("🟡 Targeted ID: ${highlightedBookingId.value}");
//
//     } catch (e) {
//       debugPrint("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void changeFilter(String status) {
//     selectedFilter.value = status;
//     if (status == "All") {
//       filteredBookings.assignAll(allBookings);
//     } else if (status == "Upcoming") {
//       final now = DateTime.now().toUtc();
//       filteredBookings.assignAll(
//         allBookings.where((b) => b.tripStatus.toLowerCase() == 'scheduled').toList(),
//       );
//     } else if (status == "InProgress") {
//       filteredBookings.assignAll(
//         allBookings
//             .where((b) => b.tripStatus.toLowerCase() == 'in_progress')
//             .toList(),
//       );
//     } else if (status == "Completed") {
//       filteredBookings.assignAll(
//         allBookings.where((b) => b.tripStatus.toLowerCase() == 'completed').toList(),
//       );
//     } else {
//       filteredBookings.assignAll(
//         allBookings
//             .where((b) => b.status.toLowerCase() == status.toLowerCase())
//             .toList(),
//       );
//     }
//   }
//
//   void setFilter(String status) {
//     changeFilter(status);
//   }
//
//   Future<void> handleBookingTap(BuildContext context, BookingHistoryModel booking) async {
//     final statusLower = booking.status.toLowerCase();
//     final tripStatusLower = booking.tripStatus.toLowerCase();
//
//     if (statusLower == 'cancelled') {
//       CustomSnackBar.showError("This booking has been cancelled.".tr);
//       return;
//     }
//
//     if (tripStatusLower == 'completed' || statusLower == 'completed') {
//       Get.toNamed(
//         AppRoute.send_complaints,
//         arguments: {'tripId': booking.tripId, 'bookingId': booking.id},
//       );
//       return;
//     }
//
//     if (tripStatusLower == 'in_progress') {
//
//       if (Get.isRegistered<TripTrackingController>()) {
//         await Get.delete<TripTrackingController>(force: true);
//       }
//
//       Get.toNamed(
//         AppRoute.TripTrackingScreen,
//         arguments: {'tripId': booking.tripId},
//       );
//       return;
//     }
//
//     if (tripStatusLower == 'scheduled' || statusLower == 'confirmed') {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const Center(
//           child: CircularProgressIndicator(color: AppColor.darkgreen),
//         ),
//       );
//
//       try {
//         final repo = Get.find<BookingRepository>();
//         final fullBookingData = await repo.fetchBookingDetails(booking.id);
//
//         Navigator.of(context).pop();
//
//         if (Get.isRegistered<TicketController>()) {
//           Get.delete<TicketController>();
//         }
//         final ticketCtrl = Get.put(TicketController());
//
//         if (booking.seatNumbers != null && booking.seatNumbers!.isNotEmpty) {
//           fullBookingData['seat_numbers'] = booking.seatNumbers!;
//         }
//
//         await ticketCtrl.setTripData(fullBookingData);
//
//         Get.find<MainLayoutController>().pushToBookings(const TicketDetailsScreen());
//       } catch (e) {
//         Navigator.of(context).pop();
//         CustomSnackBar.showError("Failed to load details: ".tr + e.toString());
//       }
//       return;
//     }
//   }
// }




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/services/api_service.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/models/booking_history_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../routes/app_routes/app_routes.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../../ticket_details/view/screen/ticket_details_screen.dart';
import '../../trip_tracking/controllers/trip_tracking_controller.dart';
import '../../trip_tracking/view/screen/trip_tracking_screen.dart';

class BookingHistoryController extends GetxController with WidgetsBindingObserver {
  var isLoading = true.obs;
  var allBookings = <BookingHistoryModel>[].obs;
  var filteredBookings = <BookingHistoryModel>[].obs;
  var selectedFilter = "All".obs;
  var highlightedBookingId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchBookings();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void setHighlightedId(int id) {
    highlightedBookingId.value = id;
    print("🟢 Highlighted ID updated to: $id");

    Future.delayed(const Duration(seconds: 1), () {
      if (highlightedBookingId.value == id) {
        clearHighlight();
        print("⏱️ Highlight cleared automatically.");
      }
    });
  }

  void clearHighlight() {
    highlightedBookingId.value = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchBookings();
    }
  }

  void removeBookingPermanently(int bookingId) {
    allBookings.removeWhere((b) => b.id == bookingId);
    filteredBookings.removeWhere((b) => b.id == bookingId);
    changeFilter(selectedFilter.value);
    print("🗑️ Booking $bookingId removed permanently from all lists");
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final BookingRepository _repository = BookingRepository();
      final bookings = await _repository.fetchBookingHistory();

      final activeBookings = bookings
          .where((b) => b.status.toLowerCase() != 'cancelled')
          .toList();
      activeBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      allBookings.assignAll(activeBookings);

      changeFilter(selectedFilter.value);

      print("🟢 Total active bookings (no merge): ${allBookings.length}");

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String status) {
    selectedFilter.value = status;

    final activeBookings = allBookings.where((b) =>
    b.status.toLowerCase() != 'cancelled'
    ).toList();

    if (status == "All") {
      filteredBookings.assignAll(activeBookings);
    } else if (status == "Upcoming") {
      filteredBookings.assignAll(
        activeBookings.where((b) => b.tripStatus.toLowerCase() == 'scheduled').toList(),
      );
    } else if (status == "InProgress") {
      filteredBookings.assignAll(
        activeBookings.where((b) => b.tripStatus.toLowerCase() == 'in_progress').toList(),
      );
    } else if (status == "Completed") {
      filteredBookings.assignAll(
        activeBookings.where((b) => b.tripStatus.toLowerCase() == 'completed').toList(),
      );
    } else {
      filteredBookings.assignAll(
        activeBookings.where((b) => b.status.toLowerCase() == status.toLowerCase()).toList(),
      );
    }
  }

  void setFilter(String status) {
    changeFilter(status);
  }

  Future<void> handleBookingTap(BuildContext context, BookingHistoryModel booking) async {
    final statusLower = booking.status.toLowerCase();
    final tripStatusLower = booking.tripStatus.toLowerCase();

    if (statusLower == 'cancelled') {
      CustomSnackBar.showError("This booking has been cancelled.".tr);
      return;
    }

    if (tripStatusLower == 'completed' || statusLower == 'completed') {
      Get.toNamed(
        AppRoute.send_complaints,
        arguments: {'tripId': booking.tripId, 'bookingId': booking.id},
      );
      return;
    }

    if (tripStatusLower == 'in_progress') {

      if (Get.isRegistered<TripTrackingController>()) {
        await Get.delete<TripTrackingController>(force: true);
      }

      Get.toNamed(
        AppRoute.TripTrackingScreen,
        arguments: {'tripId': booking.tripId},
      );
      return;
    }

    if (tripStatusLower == 'scheduled' || statusLower == 'confirmed') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColor.darkgreen),
        ),
      );

      try {
        final repo = Get.find<BookingRepository>();
        final fullBookingData = await repo.fetchBookingDetails(booking.id);

        Navigator.of(context).pop();

        if (Get.isRegistered<TicketController>()) {
          Get.delete<TicketController>();
        }
        final ticketCtrl = Get.put(TicketController());

        if (booking.seatNumbers != null && booking.seatNumbers!.isNotEmpty) {
          fullBookingData['seat_numbers'] = booking.seatNumbers!;
        }

        await ticketCtrl.setTripData(fullBookingData);

        Get.find<MainLayoutController>().pushToBookings(const TicketDetailsScreen());
      } catch (e) {
        Navigator.of(context).pop();
        CustomSnackBar.showError("Failed to load details: ".tr + e.toString());
      }
      return;
    }
  }
}