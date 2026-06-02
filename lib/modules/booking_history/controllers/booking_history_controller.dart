import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/services/api_service.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/models/booking_history_model.dart';
import '../../../data/repositories/booking_repository.dart';
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
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final BookingRepository _repository = BookingRepository();
      final bookings = await _repository.fetchBookingHistory();
      allBookings.assignAll(bookings);
      changeFilter(selectedFilter.value);

      print("🟢 Current List IDs: ${allBookings.map((b) => b.id).toList()}");
      print("🟡 Targeted ID: ${highlightedBookingId.value}");


    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void changeFilter(String status) {
    selectedFilter.value = status;
    if (status == "All") {
      filteredBookings.assignAll(allBookings);
    } else if (status == "Upcoming") {
      final now = DateTime.now().toUtc();
      filteredBookings.assignAll(
        allBookings.where((b) => b.tripStatus.toLowerCase() == 'scheduled').toList(),
      );
    } else if (status == "InProgress") {
      filteredBookings.assignAll(
        allBookings
            .where((b) =>
        b.tripStatus.toLowerCase() == 'in_progress')
            .toList(),
      );
    }
    else if (status == "Completed") {
      filteredBookings.assignAll(
        allBookings.where((b) => b.tripStatus.toLowerCase() == 'completed').toList(),
      );

    } else {
      filteredBookings.assignAll(
        allBookings
            .where((b) => b.status.toLowerCase() == status.toLowerCase())
            .toList(),
      );
    }
  }



  Future<void> handleBookingTap(BuildContext context, BookingHistoryModel booking) async {
    final statusLower = booking.status.toLowerCase();
    final tripStatusLower = booking.tripStatus.toLowerCase();

    if (statusLower == 'cancelled') {
      CustomSnackBar.showError("This booking has been cancelled.".tr);
      return;
    }

    if (tripStatusLower == 'completed' || statusLower == 'completed') {
      CustomSnackBar.showError("This trip has already ended.".tr);
      return;
    }

    if (tripStatusLower == 'in_progress') {

      if (Get.isRegistered<TripTrackingController>()) {
        await Get.delete<TripTrackingController>(force: true);
      }

      Get.put(TripTrackingController(tripId: booking.tripId));

      Get.find<MainLayoutController>().pushToBookings(
          const TripTrackingScreen()
      );
      return;
    }

    if (tripStatusLower == 'scheduled' || statusLower == 'confirmed') {

      if (Get.isRegistered<TripTrackingController>()) {
        await Get.delete<TripTrackingController>(force: true);
      }

      Get.put(TripTrackingController(tripId: booking.tripId));

      Get.find<MainLayoutController>().pushToBookings(
          const TripTrackingScreen()
      );
      return;

      // عرض الـ Loading
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) => const Center(
    //       child: CircularProgressIndicator(color: AppColor.darkgreen),
    //     ),
    //   );
    //
    //   try {
    //     final repo = Get.find<BookingRepository>();
    //     final fullBookingData = await repo.fetchBookingDetails(booking.id);
    //
    //     Navigator.of(context).pop(); // إغلاق الـ Loading
    //
    //     if (Get.isRegistered<TicketController>()) {
    //       Get.delete<TicketController>();
    //     }
    //     final ticketCtrl = Get.put(TicketController());
    //     await ticketCtrl.setTripData(fullBookingData);
    //
    //     Get.find<MainLayoutController>().pushToBookings(const TicketDetailsScreen());
    //   } catch (e) {
    //     Navigator.of(context).pop();
    //     CustomSnackBar.showError("Failed to load details: ".tr + e.toString());
    //   }
    //   return;
    }
  }


}