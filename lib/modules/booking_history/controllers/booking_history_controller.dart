import 'package:get/get.dart';

class BookingHistoryController extends GetxController {
  var selectedFilter = "All".obs;

  final List<String> dummyData = [
    "Upcoming",
    "Completed",
    "Completed",
    "Cancelled",
  ];

  var filteredBookings = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    changeFilter("All");
  }

  void changeFilter(String status) {
    selectedFilter.value = status;

    if (status == "All") {
      filteredBookings.assignAll(dummyData);
    } else {
      filteredBookings.assignAll(
          dummyData.where((item) => item == status).toList()
      );
    }
  }
}