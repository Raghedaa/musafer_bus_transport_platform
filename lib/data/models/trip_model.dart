import 'package:intl/intl.dart';
import 'package:musafer/data/models/rest_area_model.dart';
import 'package:musafer/data/models/station_model.dart';

class TripModel {
  final int id;
  final double price;
  final String departureTime;
  final String arrivalTime;
  final int availableSeats;
  final String status;
  final String originCity;
  final String destinationCity;
  final StationModel? originStation;
  final StationModel? destinationStation;
  final String companyName;
  final double rating;
  final int reviewsCount;
  final bool isDirect;
  final String tripDate;
  final String duration;

  final String driverName;
  final double driverRating;
  final String vehiclePlate;
  final Map<String, dynamic> rawVehicle;
  final List<dynamic> rawSeatMap;
  final List<RestAreaModel> restAreas;

  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;


  final double? currentLat;
  final double? currentLng;

  TripModel({
    required this.id,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.status,
    required this.originCity,
    required this.destinationCity,
    required this.originStation,
    required this.destinationStation,
    required this.companyName,
    required this.rating,
    required this.reviewsCount,
    required this.isDirect,
    required this.tripDate,
    required this.duration,

    required this.driverName,
    required this.driverRating,
    required this.vehiclePlate,
    required this.rawVehicle,
    required this.rawSeatMap,
    required this.restAreas,

    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,

    this.currentLat,
    this.currentLng,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {

    final companyObj = json['company'] ?? {};

    double oLat = double.tryParse(json['origin_city']?['latitude']?.toString() ?? '0.0') ?? 0.0;
    double oLng = double.tryParse(json['origin_city']?['longitude']?.toString() ?? '0.0') ?? 0.0;
    double dLat = double.tryParse(json['destination_city']?['latitude']?.toString() ?? '0.0') ?? 0.0;
    double dLng = double.tryParse(json['destination_city']?['longitude']?.toString() ?? '0.0') ?? 0.0;

    double _parseDynamicDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble(); // إذا كان int أو double
      if (value is String) return double.tryParse(value) ?? 0.0; // إذا كان "2.00"
      return 0.0;
    }
    DateTime depDt = DateTime.parse(json['departure_time'] ?? DateTime.now().toString());
    DateTime arrDt = DateTime.parse(json['estimated_arrival_time'] ?? DateTime.now().toString());


    final currentLoc = json['current_location'];
    final double? curLat = currentLoc != null
        ? double.tryParse(currentLoc['latitude']?.toString() ?? '')
        : null;
    final double? curLng = currentLoc != null
        ? double.tryParse(currentLoc['longitude']?.toString() ?? '')
        : null;


    return TripModel(
      id: json['id'] ?? 0,
      price: (json['base_fare'] ?? 0).toDouble(),
      departureTime: json['departure_time'],
      arrivalTime: json['estimated_arrival_time'],
      availableSeats: json['available_seats'] ?? 0,
      status: json['status'] ?? 'scheduled',
      originCity: json['origin_city']?['name'] ?? '',
      destinationCity: json['destination_city']?['name'] ?? '',originStation: json['origin_station'] != null
        ? StationModel.fromJson(json['origin_station'])
        : null,
      destinationStation: json['destination_station'] != null
          ? StationModel.fromJson(json['destination_station'])
          : null,
      companyName: json['company']?['name'] ?? '',
      rating: _parseDynamicDouble(json['company']?['rating']),
      reviewsCount: 120,
      isDirect: true,
      tripDate: DateFormat('yyyy-MM-dd').format(depDt),
      duration: json['estimated_duration_hhmm'] ?? '00:00',
      driverName: json['driver']?['name'] ?? 'Capt. Driver',
      driverRating: double.tryParse(json['driver']?['rating']?.toString() ?? '0.0') ?? 0.0,
      vehiclePlate: json['vehicle']?['plate_number'] ?? 'N/A',
      rawVehicle: json['vehicle'] ?? {},
      rawSeatMap: json['seat_map'] ?? [],

      restAreas: (json['rest_areas'] as List? ?? [])
          .map((e) => RestAreaModel.fromJson(e))
          .toList()
        ..sort((a, b) => (a.stopOrder ?? 0).compareTo(b.stopOrder ?? 0)),

      originLat: oLat,
      originLng: oLng,
      destLat: dLat,
      destLng: dLng,

      currentLat: curLat,
      currentLng: curLng,

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'base_fare': price,
      'departure_time': departureTime,
      'estimated_arrival_time': arrivalTime,
      'available_seats': availableSeats,
      'status': status,
      'origin_city': {'name': originCity},
      'destination_city': {'name': destinationCity},
      'origin_station': originStation?.toJson(),
      'destination_station': destinationStation?.toJson(),
      'company': {'name': companyName, 'rating': rating},
      'estimated_duration_hhmm': duration,
      'driver': {
        'name': driverName,
        'rating': driverRating.toString(),
      },
      'vehicle': rawVehicle,
      'seat_map': rawSeatMap,
      'rest_areas': restAreas.map((e) => e.toJson()).toList(),
    };
  }

}