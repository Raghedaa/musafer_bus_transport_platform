
class BookingDetailsModel {
  final String id;
  final String pnr;
  final int totalPrice;
  final String status;
  final String paymentMethod;
  final List<int> seatNumbers;
  final String fromCity;
  final String toCity;
  final String departureTime;
  final String estimatedArrivalTime;
  final String companyName;
  final String companyRating;
  final String vehiclePlate;
  final String driverName;
  final int availableSeats;

  BookingDetailsModel({
    required this.id,
    required this.pnr,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.seatNumbers,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.estimatedArrivalTime,
    required this.companyName,
    required this.companyRating,
    required this.vehiclePlate,
    required this.driverName,
    required this.availableSeats,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    // ✅ يشتغل مع API (فيه 'data') ومع الكاش (مباشرة بدون 'data')
    final data = json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;
    final trip = (data['trip'] ?? {}) as Map<String, dynamic>;
    final originCity = (trip['origin_city'] ?? {}) as Map<String, dynamic>;
    final destCity = (trip['destination_city'] ?? {}) as Map<String, dynamic>;
    final company = (trip['company'] ?? {}) as Map<String, dynamic>;

    return BookingDetailsModel(
      id: data['id']?.toString() ?? '0',
      pnr: data['pnr_code'] ?? '---',
      totalPrice: (data['total_price'] ?? 0) is int
          ? data['total_price'] ?? 0
          : int.tryParse(data['total_price'].toString()) ?? 0,
      status: data['status'] ?? 'N/A',
      paymentMethod: data['payment_method'] ?? 'cash',
      // ✅ هنا كان الكراش — null safety
      seatNumbers: data['seat_numbers'] != null
          ? List<int>.from(data['seat_numbers'])
          : [],
      fromCity: originCity['name'] ?? 'Unknown',
      toCity: destCity['name'] ?? 'Unknown',
      departureTime: trip['departure_time'] ?? '',
      estimatedArrivalTime: trip['estimated_arrival_time'] ?? '',
      companyName: company['name'] ?? 'Unknown',
      companyRating: company['rating']?.toString() ?? '0.0',
      vehiclePlate: data['vehicle_plate'] ?? 'N/A',
      driverName: data['driver_name'] ?? 'Driver',
      availableSeats: trip['available_seats'] ?? 0,
    );
  }

  String getFormattedDepartureTime() {
    try {
      final dateTime = DateTime.parse(departureTime);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute';
    } catch (e) {
      return '--:--';
    }
  }

  String getFormattedArrivalTime() {
    try {
      final dateTime = DateTime.parse(estimatedArrivalTime);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'مساءً' : 'صباحاً';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return '--:--';
    }
  }

  String getDuration() {
    try {
      final departure = DateTime.parse(departureTime);
      final arrival = DateTime.parse(estimatedArrivalTime);
      final difference = arrival.difference(departure);
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      return '${hours}h ${minutes > 0 ? '${minutes}m' : ''}';
    } catch (e) {
      return '--h';
    }
  }
}