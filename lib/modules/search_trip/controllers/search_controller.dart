import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripSearchController extends GetxController {
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final customPassengerController = TextEditingController();

  var origin = "Cairo, Egypt".obs;
  var destination = "Where are you going?".obs;
  var departureDate = "May 24, 2024".obs;
  var passengers = "1 Adult".obs;

  var isEditingOrigin = false.obs;
  var isEditingDestination = false.obs;

  @override
  void onInit() {
    originController.text = origin.value;
    destinationController.text = destination.value == "Where are you going?"
        ? ""
        : destination.value;
    super.onInit();
  }

  @override
  void onClose() {
    originController.dispose();
    destinationController.dispose();
    customPassengerController.dispose();
    super.onClose();
  }

  void swapLocations() {
    String temp = origin.value;
    origin.value = destination.value;
    destination.value = temp;
    originController.text = origin.value;
    destinationController.text = destination.value;
  }

  void updateDateValue(String date) => departureDate.value = date;

  void updatePassengersValue(String count) => passengers.value = count;
}
