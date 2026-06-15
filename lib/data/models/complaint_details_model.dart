import 'city_model.dart';

class ComplaintDetailsModel {
  final int id;
  final String status, description, createdAt;
  final String categoryName, companyName, driverName, pnrCode, plateNumber;
  final String originCity, destinationCity, departureTime, arrivalTime;
  final List<String> attachmentUrls;
  final String companyEmail, companyPhone, companyAddress;
  final String driverUsername, driverPhone;
  ComplaintDetailsModel({
    required this.id, required this.status, required this.description,
    required this.createdAt, required this.categoryName, required this.companyName,
    required this.driverName, required this.pnrCode, required this.plateNumber,
    required this.originCity, required this.destinationCity,
    required this.departureTime, required this.arrivalTime,
    required this.attachmentUrls,
    required this.companyEmail,
    required this.companyPhone,
    required this.companyAddress,
    required this.driverUsername,
    required this.driverPhone,

  });

  factory ComplaintDetailsModel.fromJson(Map<String, dynamic> json, List<CityModel> cities) {
    int originId = json['trip']?['origin_city_id'] ?? 0;
    int destId = json['trip']?['destination_city_id'] ?? 0;

    CityModel origin = cities.firstWhere(
            (c) => c.id == originId,
        orElse: () => CityModel(id: 0, name: "Unknown")
    );

    CityModel destination = cities.firstWhere(
            (c) => c.id == destId,
        orElse: () => CityModel(id: 0, name: "Unknown")
    );

    return ComplaintDetailsModel(
      id: json['id'],
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      categoryName: json['category']?['name_ar'] ?? '',
      companyName: json['company']?['name'] ?? '',
      driverName: json['driver']?['user']?['name'] ?? '',
      pnrCode: json['booking']?['pnr_code'] ?? '',
      plateNumber: json['vehicle']?['plate_number'] ?? '',
      attachmentUrls: (json['attachments'] as List?)
          ?.map((e) => e['url'].toString())
          .toList() ?? [],

      originCity: origin.name,
      destinationCity: destination.name,
      departureTime: json['trip']?['departure_time'] ?? '',
      arrivalTime: json['trip']?['estimated_arrival_time'] ?? '',


      companyEmail: json['company']?['email'] ?? '',
      companyPhone: json['company']?['phone'] ?? '',
      companyAddress: json['company']?['address'] ?? '',
      driverUsername: json['driver']?['user']?['username'] ?? '',
      driverPhone: json['driver']?['user']?['phone_number'] ?? '',
    );
  }
}