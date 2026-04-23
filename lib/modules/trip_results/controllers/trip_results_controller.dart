import 'package:get/get.dart';
import 'package:musafer/data/models/trip_result_model.dart';

import '../../search_trip/controllers/search_controller.dart';

class TripResultsController extends GetxController {

  final searchController = Get.find<TripSearchController>();

  var travelDate = "".obs;
  var passengers = "".obs;
  var selectedFilter = "Filters".obs;

  var origin = "".obs;
  var destination = "".obs;

  var trips = <TripResultModel>[].obs;

  TripResultModel? chosenTrip;

  void selectTrip(TripResultModel trip) {
    chosenTrip = trip;
    Get.toNamed('/select_seat', id: 1);
  }
  @override
  void onInit() {
    super.onInit();
    travelDate.value = searchController.departureDate.value;
    passengers.value = searchController.passengers.value;
    origin.value = searchController.origin.value;
    destination.value = searchController.destination.value;
    loadTrips();
  }

  void loadTrips() {
    trips.value = [
      TripResultModel(
        id: "1",
        companyName: "TransLine Express",
        logo: "bus_icon",
        rating: 4.8,
        reviewsCount: 1200,
        price: 45.0,
        departureTime: "08:30 AM",
        arrivalTime: "02:15 PM",
        departureTerminal: "SF Terminal",
        arrivalTerminal: "LA Union",
        duration: "5h 45m",
        tripDate: travelDate.value,

      ),
      TripResultModel(
        id: "2",
        companyName: "Silver Bullet",
        logo: "bus_icon",
        rating: 4.5,
        reviewsCount: 850,
        price: 38.0,
        departureTime: "09:15 AM",
        arrivalTime: "03:30 PM",
        departureTerminal: "Damascus",
        arrivalTerminal: "Homs",
        duration: "6h 15m",
        isDirect: false,
        tag: "NEXT DEPARTURE",
        tripDate: travelDate.value,

      ),
    ];
  }

  void applyFilter(String filterType) {
    selectedFilter.value = filterType;
  }
}