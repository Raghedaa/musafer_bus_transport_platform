import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/city_model.dart';
import '../../../data/repositories/trip_repository.dart';
import 'package:intl/intl.dart';



class TripSearchController extends GetxController {
  final TripRepository _tripRepository = Get.put(TripRepository());

  final originController = TextEditingController();
  final destinationController = TextEditingController();

  var selectedOriginCity = Rxn<CityModel>();
  var selectedDestinationCity = Rxn<CityModel>();

  var departureDate = "".obs;
  var departureTime = "Select Time".obs;

  var isCardExpanded = false.obs;
  var isPopularLoading = false.obs;
  var isCitiesLoading = false.obs;

  var popularTrips = <TripModel>[].obs;
  var cities = <CityModel>[].obs;


  @override
  void onClose() {
    originController.dispose();
    destinationController.dispose();
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    await Hive.box('popular_trips_box').clear();
    departureDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchCities();
    loadOfflineData();
    fetchPopularTrips();
    super.onInit();
  }

  void loadOfflineCities() {
    try {
      final box = Hive.box('cities_box');
      final cached = box.get('cities_list');
      if (cached != null) {
        List<dynamic> decoded;
        if (cached is String) {
          decoded = jsonDecode(cached);
        } else if (cached is List) {
          decoded = cached;
        } else {
          return;
        }
        final loadedCities = decoded.map((json) => CityModel.fromJson(json)).toList();
        cities.assignAll(loadedCities);
        print("✅ تم تحميل ${loadedCities.length} مدينة من الكاش");
      }
    } catch (e) {
      print("❌ فشل تحميل المدن من الكاش: $e");
    }
  }



  void loadOfflineData() {
    try {
      final box = Hive.box('popular_trips_box');

      final dynamic cached = box.get('popular_list');

      if (cached != null && cached is List) {
        popularTrips.assignAll(
            cached.map((item) {
              final Map<String, dynamic> map = Map<String, dynamic>.from(item as Map);
              return TripModel.fromJson(map);
            }).toList()
        );
        print("✅ تم تحميل ${popularTrips.length} رحلة من الكاش");
      }
    } catch (e) {
      print("❌ خطأ في تحميل البيانات من الكاش: $e");
    }
  }

  void toggleSearchCard() => isCardExpanded.value = !isCardExpanded.value;

  void swapLocations() {
    if (selectedOriginCity.value != null || selectedDestinationCity.value != null) {
      var temp = selectedOriginCity.value;
      selectedOriginCity.value = selectedDestinationCity.value;
      selectedDestinationCity.value = temp;
    }
  }

  void updateDateValue(String date) => departureDate.value = date;
  void updateTimeValue(String time) => departureTime.value = time;

  Future<void> fetchCities() async {
    try {
      isCitiesLoading.value = true;
      var fetchedCities = await _tripRepository.fetchCities();
      cities.assignAll(fetchedCities);

      if (cities.isNotEmpty) {
        selectedOriginCity.value = null;
      }
    } catch (e) {
    } finally {
      isCitiesLoading.value = false;
    }
  }

  Future<void> fetchPopularTrips() async {
    try {
      isPopularLoading.value = true;
      var trips = await _tripRepository.fetchPopularTrips();
      popularTrips.assignAll(trips);
    } catch (e) {
    } finally {
      isPopularLoading.value = false;
    }
  }

  Map<String, dynamic> prepareSearchArguments() {
    return {
      'origin_id': selectedOriginCity.value?.id ?? "",
      'origin_name': selectedOriginCity.value?.name ?? "",
      'destination_id': selectedDestinationCity.value?.id ?? "",
      'destination_name': selectedDestinationCity.value?.name ?? "Anywhere",
      'date': departureDate.value,
      'time': departureTime.value == "Select Time" ? "" : departureTime.value,
    };
  }
}