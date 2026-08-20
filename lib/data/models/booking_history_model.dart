class BookingHistoryModel {
  final int id;
  String status;
  String tripStatus;
  String pnr;
  final String fromCity;
  final String toCity;
  final String dateTime;
  final int tripId;
  DateTime createdAt;
  List<String>? seatNumbers;
  Map<String, dynamic>? rawTrip;

  BookingHistoryModel({
    required this.tripId,
    required this.id,
    required this.status,
    required this.tripStatus,
    required this.pnr,
    required this.fromCity,
    required this.toCity,
    required this.dateTime,
    required this.createdAt,
    this.seatNumbers,
    this.rawTrip,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    List<String>? seats;
    final seatData = json['seat_numbers'];
    if (seatData is List) {
      seats = seatData.map((s) => s.toString().trim()).where((s) => s.isNotEmpty).toList();
    } else if (seatData != null) {
      seats = [seatData.toString().trim()];
    }

    return BookingHistoryModel(
      id: json['id'] as int,
      tripId: json['trip']['id'] as int,
      status: json['status'] ?? "N/A",
      tripStatus: json['trip']?['status'] ?? "N/A",
      pnr: json['pnr_code'] ?? "---",
      fromCity: json['trip']['origin_city']['name'] ?? "Unknown",
      toCity: json['trip']['destination_city']['name'] ?? "Unknown",
      dateTime: json['trip']['departure_time'] ?? "",
      createdAt: parseDateTime(json['created_at']),
      seatNumbers: seats,
      rawTrip: json['trip'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "pnr_code": pnr,
      "status": status,
      "trip": {
        "id": tripId,
        "status": tripStatus,
        "departure_time": dateTime,
        "origin_city": {"name": fromCity},
        "destination_city": {"name": toCity},
      },
      "created_at": createdAt.toIso8601String(),
      "seat_numbers": seatNumbers ?? [],
    };
  }

  BookingHistoryModel copyWith({
    int? id,
    String? status,
    String? tripStatus,
    String? pnr,
    String? fromCity,
    String? toCity,
    String? dateTime,
    int? tripId,
    DateTime? createdAt,
    List<String>? seatNumbers,
    Map<String, dynamic>? rawTrip,
  }) {
    return BookingHistoryModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      status: status ?? this.status,
      tripStatus: tripStatus ?? this.tripStatus,
      pnr: pnr ?? this.pnr,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      dateTime: dateTime ?? this.dateTime,
      createdAt: createdAt ?? this.createdAt,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      rawTrip: rawTrip ?? this.rawTrip,
    );
  }
}