import 'package:musafer/data/models/subscription_plan_model.dart';

class MySubscriptionModel {
  final int id;
  final int remainingTrips;
  final String status;
  final String startsAt;
  final String expiresAt;
  final SubscriptionPlanModel plan;

  MySubscriptionModel({
    required this.id, required this.remainingTrips, required this.status,
    required this.startsAt, required this.expiresAt, required this.plan,
  });

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) {
    return MySubscriptionModel(
      id: json['id'] ?? 0,
      remainingTrips: json['remaining_trips'] ?? 0,
      status: json['status'] ?? "",
      startsAt: json['starts_at'] ?? "",
      expiresAt: json['expires_at'] ?? "",
      plan: SubscriptionPlanModel.fromJson(json['plan'] ?? {}),
    );
  }
}