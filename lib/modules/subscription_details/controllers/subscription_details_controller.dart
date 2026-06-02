import 'package:get/get.dart';
import '../../../../data/models/subscription_plan_model.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/repositories/subscription_repository.dart';

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
    bool success = await _repo.purchasePlan(plan.value!.id);
    isSubscribing.value = false;

    if (success) {
      Get.back();
      CustomSnackBar.showSuccess("Subscribed successfully!");
    } else {
      CustomSnackBar.showError("Failed to subscribe, please try again.");
    }
  }

}