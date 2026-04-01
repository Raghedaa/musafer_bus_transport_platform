import 'package:get/get.dart';

class SubscriptionController extends GetxController {

  var remainingTrips = 12.obs;
  var selectedPlan = "Corporate Elite".obs;

  final List<Map<String, dynamic>> plans = [
    {"title": "Standard Plan", "trips": "10 Intercity Trips", "price": "96", "oldPrice": "120", "icon": "bus"},
    {"title": "Corporate Elite", "trips": "25 Intercity Trips", "price": "224", "oldPrice": "280", "isPopular": true, "icon": "medal"},
    {"title": "Enterprise", "trips": "50 Intercity Trips", "price": "400", "oldPrice": "500", "icon": "building"},
  ];
}