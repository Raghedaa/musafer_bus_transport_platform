import 'package:get/get.dart';

import '../../../data/models/booking_history_model.dart';

class BookingHistoryController extends GetxController {
  var selectedFilter = "All".obs;

  final List<BookingModel> allBookings = [
    BookingModel(id: "1", status: "Upcoming", pnr: "#BX8291", fromCity: "Beirut", fromStation: "Charles Helou", toCity: "Tripoli", toStation: "Al Nour Square", dateTime: "Oct 24, 08:30 AM"),
    BookingModel(id: "2", status: "Upcoming", pnr: "#BX8291", fromCity: "Damascus", fromStation: "Highway", toCity: "Homs", toStation: "Helou", dateTime: "Oct 30, 06:00 AM"),
    BookingModel(id: "3", status: "Completed", pnr: "#BX8292", fromCity: "Sidon", fromStation: "Main Gate", toCity: "Beirut", toStation: "Charles Helou", dateTime: "Oct 20, 10:00 AM"),
    BookingModel(id: "4", status: "Cancelled", pnr: "#BX8293", fromCity: "Byblos", fromStation: "Highway", toCity: "Beirut", toStation: "Charles Helou", dateTime: "Oct 18, 04:15 PM"),
  ];

  var filteredBookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    changeFilter("All");
  }

  void changeFilter(String status) {
    selectedFilter.value = status;
    if (status == "All") {
      filteredBookings.assignAll(allBookings);
    } else {
      filteredBookings.assignAll(
          allBookings.where((booking) => booking.status == status).toList()
      );
    }
  }
}