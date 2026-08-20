import 'package:get/get.dart';

import '../../../data/models/my_subscription_model.dart';
import '../../../data/repositories/subscription_repository.dart';

class MySubscriptionsController extends GetxController {
  final SubscriptionRepository _repo = SubscriptionRepository();
  var subscriptions = <MySubscriptionModel>[].obs;
  var isLoading = true.obs;

  var highlightedSubscriptionId = RxnInt();

  @override
  void onInit() {
    fetchMySubscriptions();
    super.onInit();
  }

  Future<void> fetchMySubscriptions() async {
    isLoading.value = true;
    subscriptions.value = await _repo.fetchMySubscriptions();
    isLoading.value = false;
  }

  void setHighlightedId(int id) {
    highlightedSubscriptionId.value = id;
    Future.delayed(const Duration(seconds: 4), () {
      if (highlightedSubscriptionId.value == id) {
        highlightedSubscriptionId.value = null;
      }
    });
  }
}