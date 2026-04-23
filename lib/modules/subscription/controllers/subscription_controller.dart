import 'package:get/get.dart';
import '../../../data/models/subscription_plan_model.dart';

class SubscriptionController extends GetxController {

  var remainingTrips = 12.obs;
  var selectedPlan = "Corporate Elite".obs;

  final List<SubscriptionPlanModel> plans = [
    SubscriptionPlanModel(
        title: "Standard Plan".tr,
        trips: "10 ${"Intercity Trips".tr}",
        price: "96",
        oldPrice: "120",
        icon: "bus"
    ),
    SubscriptionPlanModel(
        title: "Corporate Elite".tr,
        trips: "25 ${"Intercity Trips".tr}",
        price: "224",
        oldPrice: "280",
        isPopular: true,
        icon: "medal"
    ),
    SubscriptionPlanModel(
        title: "Enterprise".tr,
        trips: "50 ${"Intercity Trips".tr}",
        price: "400",
        oldPrice: "500",
        icon: "building"
    ),
  ];
}