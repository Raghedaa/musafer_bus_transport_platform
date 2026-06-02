import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/models/subscription_plan_model.dart';
import '../../../data/repositories/subscription_repository.dart';


class SubscriptionController extends GetxController {
  final _repo = SubscriptionRepository();
  var plans = <SubscriptionPlanModel>[].obs;
  var isLoading = true.obs;
  var selectedPlan = "".obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  Future<void> loadPlans() async {
    if (plans.isEmpty) isLoading.value = true;

    errorMessage.value = "";

    try {
      final data = await _repo.fetchPlans();
      if (data.isEmpty) {
        errorMessage.value = "No subscription plans available.".tr;
      } else {
        plans.value = data;
      }
    } catch (e) {
      if (plans.isEmpty) {
        errorMessage.value = "Check your internet connection.".tr;
      }
    } finally {
      isLoading.value = false;
    }
  }


  void clearSelection() {
    selectedPlan.value = "";
  }


}