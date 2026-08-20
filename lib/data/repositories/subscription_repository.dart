import 'dart:convert'; // ✅ أضف هاد
import 'package:hive/hive.dart';
import '../models/my_subscription_model.dart';
import '../models/subscription_plan_model.dart';
import '../providers/subscription_provider.dart';

class SubscriptionRepository {
  final _provider = SubscriptionProvider();
  final Box _box = Hive.box('subscription_box');

  Future<List<SubscriptionPlanModel>> fetchPlans() async {
    try {
      final res = await _provider.getPlans();
      if (res.statusCode == 200 && res.data != null) {
        final List data = res.data['data'];
        await _box.put('plans', jsonEncode(data));
        return data.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
      }
    } catch (e) {
      final cached = _box.get('plans');
      if (cached != null) {
        final List data = jsonDecode(cached as String);
        return data
            .map((e) => SubscriptionPlanModel.fromJson(
            Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return [];
  }

  Future<SubscriptionPlanModel?> fetchPlanDetails(int id) async {
    try {
      final res = await _provider.getPlanDetails(id);
      if (res.statusCode == 200 && res.data != null) {
        final data = res.data['data'];
        await _box.put('plan_$id', jsonEncode(data));
        return SubscriptionPlanModel.fromJson(data);
      }
    } catch (e) {
      final cached = _box.get('plan_$id');
      if (cached != null) {
        return SubscriptionPlanModel.fromJson(jsonDecode(cached));
      }
    }
    return null;
  }

  Future<bool> purchasePlan(int planId) async {
    try {
      final res = await _provider.purchaseSubscription(planId);
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MySubscriptionModel>> fetchMySubscriptions() async {
    try {
      final res = await _provider.getMySubscriptions();
      if (res.statusCode == 200 && res.data != null) {
        final List data = res.data['data'];
        await _box.put('my_subs', jsonEncode(data));
        return data.map((e) => MySubscriptionModel.fromJson(e)).toList();
      }
    } catch (e) {
      final cached = _box.get('my_subs');
      if (cached != null) {
        final List data = jsonDecode(cached as String);
        return data.map((e) => MySubscriptionModel.fromJson(e)).toList();
      }
    }
    return [];
  }
}