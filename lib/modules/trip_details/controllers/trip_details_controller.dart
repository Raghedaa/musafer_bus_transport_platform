import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musafer/data/models/trip_model.dart';
import 'package:musafer/data/repositories/trip_repository.dart';

import '../../../core/services/api_service.dart';



class TripDetailsController extends GetxController {


  final TripRepository _tripRepository = Get.find<TripRepository>();
  final Rxn<TripModel> trip = Rxn<TripModel>();

  var isDataLoaded = false.obs;
  var isLoadingError = false.obs;



  @override
  void onInit() {
    super.onInit();
    final int? tripId = Get.arguments?['tripId'];
    print("🔁 onInit: tripId = $tripId");
    if (tripId != null) {
      loadTripDataById(tripId);
    } else {
      isLoadingError.value = true;
      print("❌ لم يتم تمرير tripId إلى الشاشة");
    }
  }


  Future<void> refreshTripDetails() async {
    if (trip.value != null) {
      await loadTripDataById(trip.value!.id, isRefresh: true);
    }
  }

  Future<void> loadTripDataById(int id, {bool isRefresh = false}) async {
    if (!isRefresh) {
      isDataLoaded.value = false;
      isLoadingError.value = false;
    }
    try {
      final result = await _tripRepository.fetchTripDetails(id);
      trip.value = result;
      isDataLoaded.value = true;
      print("✅ loadTripDataById: isDataLoaded = true");
    } catch (e) {
      print("❌ خطأ: $e");
      if (trip.value == null) {
        isLoadingError.value = true;
        isDataLoaded.value = false;
      }
    }
  }

}