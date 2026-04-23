class SubscriptionPlanModel {
  final String title;
  final String trips;
  final String price;
  final String oldPrice;
  final String icon;
  final bool isPopular;

  SubscriptionPlanModel({
    required this.title,
    required this.trips,
    required this.price,
    required this.oldPrice,
    required this.icon,
    this.isPopular = false,
  });
}