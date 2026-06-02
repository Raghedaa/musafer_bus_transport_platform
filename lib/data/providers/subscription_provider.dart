import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio; // استيراد dio لإعطائه اسماً مستعاراً
import '../../core/services/api_service.dart';

class SubscriptionProvider extends GetConnect {
  final ApiService _api = Get.find<ApiService>();

  Future<dio.Response> getPlans() => _api.get(endPoint: 'passenger/subscription-plans');

  Future<dio.Response> getPlanDetails(int id) => _api.get(endPoint: 'passenger/subscription-plans/$id');

  Future<dio.Response> purchaseSubscription(int planId) async {

    String idempotencyKey = "sub-purchase-${DateTime.now().millisecondsSinceEpoch}";

    return await _api.post(
      endPoint: 'passenger/my-subscriptions/purchase',
      data: {
        'plan_id': planId,
      },
      headers: {
        'idempotency-key': idempotencyKey,
      },
    );
  }

  Future<dio.Response> getMySubscriptions() =>
      _api.get(endPoint: 'passenger/my-subscriptions');
}