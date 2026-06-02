class SubscriptionPlanModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String type;
  final double? discountPercentage;
  final int totalTrips;
  final int validityDays;
  final Map<String, dynamic> conditions;
  final String companyName;
  final String companyPhone;
  final String companyRating;

  SubscriptionPlanModel({
    required this.id, required this.name, required this.description,
    required this.price, required this.type, this.discountPercentage,
    required this.totalTrips, required this.validityDays,
    required this.conditions, required this.companyName,
    required this.companyPhone, required this.companyRating,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    final company = json['company'] ?? {};
    return SubscriptionPlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      price: double.tryParse(json['price']?.toString() ?? "0") ?? 0.0,
      type: json['type'] ?? "",
      discountPercentage: json['discount_percentage'] != null ? double.tryParse(json['discount_percentage'].toString()) : null,
      totalTrips: json['total_trips'] ?? 0,
      validityDays: json['validity_days'] ?? 0,
      conditions: json['conditions'] ?? {},
      companyName: company['name'] ?? "Unknown",
      companyPhone: company['phone'] ?? "N/A",
      companyRating: company['average_rating']?.toString() ?? "0.0",
    );
  }
}