class TripResultModel {
  final String id;
  final String companyName;
  final String logo;
  final double rating;
  final int reviewsCount;
  final double price;
  final String departureTime;
  final String arrivalTime;
  final String departureTerminal;
  final String arrivalTerminal;
  final String duration;
  final bool isDirect;
  final String? tag;

  TripResultModel({
    required this.id,
    required this.companyName,
    required this.logo,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.duration,
    this.isDirect = true,
    this.tag,
  });

// لاحقاً يمكنك إضافة FromJson هنا للربط مع الـ API
}