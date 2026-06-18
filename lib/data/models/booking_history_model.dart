class BookingHistoryModel {
  final int id;
   String status;
   String tripStatus;
  final String pnr;
  final String fromCity;
  final String toCity;
  final String dateTime;
  final int tripId;

  BookingHistoryModel({
    required this.tripId,
    required this.id,
    required this.status,
    required this.tripStatus,
    required this.pnr,
    required this.fromCity,
    required this.toCity,
    required this.dateTime,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingHistoryModel(
      id: json['id'] as int,
      tripId: json['trip']['id'] as int,// تحويل إلى int مباشرة
      status: json['status'] ?? "N/A",
      tripStatus: json['trip']?['status'] ?? "N/A",
      pnr: json['pnr_code'] ?? "---",
      fromCity: json['trip']['origin_city']['name'] ?? "Unknown",
      toCity: json['trip']['destination_city']['name'] ?? "Unknown",
      dateTime: json['trip']['departure_time'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "pnr_code": pnr,
      "status": status,
      "trip": {
        "status": tripStatus,
        "departure_time": dateTime,
        "origin_city": {"name": fromCity},
        "destination_city": {"name": toCity},
      },
    };
  }


  BookingHistoryModel copyWith({
    String? tripStatus,
    String? status,
  }) {
    return BookingHistoryModel(
      id: this.id,
      tripId: this.tripId,
      pnr: this.pnr,
      fromCity: this.fromCity,
      toCity: this.toCity,
      dateTime: this.dateTime,
      status: status ?? this.status,
      tripStatus: tripStatus ?? this.tripStatus,
    );
  }
}