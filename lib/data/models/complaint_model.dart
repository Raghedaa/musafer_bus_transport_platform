class ComplaintModel {
  final int id;
  final int? tripId;
  final int? bookingId;
  final int? categoryId;
  final String? categoryName;
  final String description;
  final String? status;
  final String? createdAt;

  ComplaintModel({
    required this.id,
    this.tripId,
    this.bookingId,
    this.categoryId,
    this.categoryName,
    required this.description,
    this.status,
    this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      tripId: json['trip_id'],
      bookingId: json['booking_id'],
      categoryId: json['complaint_category_id'] ?? json['category']?['id'],
      categoryName: json['category']?['name_ar'] ??
          json['category']?['name'] ??
          json['complaint_category']?['name_ar'],
      description: json['description'] ?? '',
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'trip_id': tripId,
    'booking_id': bookingId,
    'complaint_category_id': categoryId,
    'category_name': categoryName,
    'description': description,
    'status': status,
    'created_at': createdAt,
  };
}