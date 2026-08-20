import 'package:get/get.dart';
import '../../../../data/models/subscription_plan_model.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/repositories/subscription_repository.dart';
import 'package:dio/dio.dart';

import '../../profile/controller/profile_controller.dart';


class SubscriptionDetailsController extends GetxController {
  Rxn<SubscriptionPlanModel> plan = Rxn<SubscriptionPlanModel>();
  var isSubscribing = false.obs;

  final SubscriptionRepository _repo = SubscriptionRepository();


  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is SubscriptionPlanModel) {
      plan.value = Get.arguments;
    }
  }

  void setPlan(SubscriptionPlanModel p) {
    plan.value = p;
  }


  Future<void> subscribe() async {
    if (plan.value == null) return;

    isSubscribing.value = true;
    try {
      bool success = await _repo.purchasePlan(plan.value!.id);
      if (success) {

        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchData();
        }
        Get.back();
        CustomSnackBar.showSuccess("Subscribed successfully!".tr);
      } else {
        CustomSnackBar.showError("failed_to_subscribe".tr);
      }
    } catch (e) {
      print("Subscription Error: $e");

      if (e is DioException && e.response != null) {
        final responseData = e.response!.data;
        String? serverMessage = responseData['message']?.toString();

        if (serverMessage != null && serverMessage.contains("Insufficient funds")) {
          CustomSnackBar.showError("insufficient_funds_subscription".tr);
        } else {
          CustomSnackBar.showError(serverMessage?.tr ?? "failed_to_subscribe".tr);
        }
      } else {
        CustomSnackBar.showError("failed_to_subscribe".tr);
      }
    } finally {
      isSubscribing.value = false;
    }
  }
}