import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/trip_model.dart';
import '../../../../data/repositories/trip_repository.dart';
import 'package:intl/intl.dart';

class TripResultsController extends GetxController {
  final TripRepository _tripRepository = TripRepository();

  var travelDate = "".obs;
  var travelTime = "".obs;
  var originName = "".obs;
  var destinationName = "".obs;

  String _originId = "";
  String _destinationId = "";

  var selectedFilter = "No Filter".obs;
  var isLoading = false.obs;

  final _allTrips = <TripModel>[];
  var trips = <TripModel>[].obs;

  TripModel? chosenTrip;

  @override
  void onInit() {
    super.onInit();
  }


  void setSearchParams({
    required String originId,
    required String originName,
    required String destinationId,
    required String destinationName,
    required String date,
    required String time,
  }) {
    _originId = originId;
    _destinationId = destinationId;
    this.originName.value = originName;
    this.destinationName.value = destinationName;
    travelDate.value = date;
    travelTime.value = time;

    fetchTripsFromServer();
  }

  Future<void> fetchTripsFromServer() async {
    try {
      isLoading.value = true;

      trips.clear();
      _allTrips.clear();

      print("🔍 بدء البحث في Controller:");
      print("  - من: $_originId");
      print("  - إلى: $_destinationId");
      print("  - التاريخ: ${travelDate.value}");
      print("  - الوقت: ${travelTime.value}");

      final fetchedTrips = await _tripRepository.fetchSearchedTrips(
        originId: _originId,
        destinationId: _destinationId,
        date: travelDate.value,
        time: travelTime.value,
      );

      print("✅ تم استلام ${fetchedTrips.length} رحلة في Controller");

      _allTrips.assignAll(fetchedTrips);
      trips.assignAll(fetchedTrips);

      applyFilter(selectedFilter.value);

    } catch (e) {
      print("❌ خطأ في جلب الرحلات: $e");
      trips.clear();
      _allTrips.clear();
    } finally {
      isLoading.value = false;
    }
  }


  void applyFilter(String filterType) {
    selectedFilter.value = filterType;

    if (filterType == "Highest Rated") {
      final sorted = List<TripModel>.from(_allTrips)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      trips.assignAll(sorted);
    } else if (filterType == "Cheapest Price") {
      final sorted = List<TripModel>.from(_allTrips)
        ..sort((a, b) => a.price.compareTo(b.price));
      trips.assignAll(sorted);
    } else if (filterType == "Earliest Time") {
      final sorted = List<TripModel>.from(_allTrips)
        ..sort((a, b) {
          try {
            final aTime = a.departureTime.split('T')[1].split('+')[0];
            final bTime = b.departureTime.split('T')[1].split('+')[0];
            return aTime.compareTo(bTime);
          } catch (e) {
            return 0;
          }
        });
      trips.assignAll(sorted);
    } else {
      trips.assignAll(_allTrips);
    }
  }

  void refreshSearch() => fetchTripsFromServer();

  void selectTrip(TripModel trip) {
    chosenTrip = trip;
    Get.toNamed('/select_seat', id: 1, arguments: {'trip': trip});
  }
}