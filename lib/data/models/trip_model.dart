
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
  final String? routePolyline;
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

  final int? companyId;
  final int? driverId;
  final int? bookingId;

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
    this.routePolyline,
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
    this.companyId,
    this.driverId,
    this.bookingId,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final companyObj = json['company'] ?? {};
    final driverObj = json['driver'] ?? {};

    String _safeString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    double _safeDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    int _safeInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    int? _safeIntNullable(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    // تحويل التواريخ بأمان
    DateTime _parseDateSafe(dynamic value) {
      if (value == null) return DateTime.now();
      try {
        return DateTime.parse(value.toString());
      } catch (e) {
        return DateTime.now();
      }
    }

    double oLat = _safeDouble(json['origin_city']?['latitude']);
    double oLng = _safeDouble(json['origin_city']?['longitude']);
    double dLat = _safeDouble(json['destination_city']?['latitude']);
    double dLng = _safeDouble(json['destination_city']?['longitude']);

    DateTime depDt = _parseDateSafe(json['departure_time']);
    DateTime arrDt = _parseDateSafe(json['estimated_arrival_time']);

    String polylineStr = _safeString(json['route_polyline'], defaultValue: '');
    String? finalPolyline = polylineStr.isEmpty ? null : polylineStr;

    final currentLoc = json['current_location'];
    final double? curLat = currentLoc != null
        ? _safeDouble(currentLoc['latitude'], defaultValue: 0.0)
        : null;
    final double? curLng = currentLoc != null
        ? _safeDouble(currentLoc['longitude'], defaultValue: 0.0)
        : null;

    return TripModel(
      id: _safeInt(json['id']),
      price: _safeDouble(json['base_fare']),
      departureTime: _safeString(json['departure_time']),
      arrivalTime: _safeString(json['estimated_arrival_time']),
      availableSeats: _safeInt(json['available_seats']),
      status: _safeString(json['status'], defaultValue: 'scheduled'),
      originCity: _safeString(json['origin_city']?['name']),
      destinationCity: _safeString(json['destination_city']?['name']),
      originStation: json['origin_station'] != null
          ? StationModel.fromJson(json['origin_station'])
          : null,
      destinationStation: json['destination_station'] != null
          ? StationModel.fromJson(json['destination_station'])
          : null,
      companyName: _safeString(companyObj['name']),
      rating: _safeDouble(companyObj['rating']),
      reviewsCount: 120,
      isDirect: true,
      tripDate: DateFormat('yyyy-MM-dd').format(depDt),
      duration: _safeString(json['estimated_duration_hhmm'], defaultValue: '00:00'),
      routePolyline: finalPolyline,
      driverName: _safeString(driverObj['name'], defaultValue: 'Capt. Driver'),
      driverRating: _safeDouble(driverObj['rating']),
      vehiclePlate: _safeString(json['vehicle']?['plate_number'], defaultValue: 'N/A'),
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
      companyId: _safeIntNullable(companyObj['id']),
      driverId: _safeIntNullable(driverObj['id']),
      bookingId: _safeIntNullable(json['booking_id'] ?? json['booking']?['id']),
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
      'company': {'id': companyId, 'name': companyName, 'rating': rating},
      'estimated_duration_hhmm': duration,
      'route_polyline': routePolyline,
      'driver': {
        'id': driverId,
        'name': driverName,
        'rating': driverRating.toString(),
      },
      'vehicle': rawVehicle,
      'seat_map': rawSeatMap,
      'rest_areas': restAreas.map((e) => e.toJson()).toList(),
      'booking_id': bookingId,
    };
  }
}



