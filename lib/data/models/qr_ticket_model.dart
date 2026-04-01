import 'dart:convert';

class QrTicketModel {
  final String id;
  final String name;
  final String seatNumber;
  final bool isPaid;
  final String route;
  final String? status; // اختياري للفلترة
  final String? date;   // اختياري

  QrTicketModel({
    required this.id,
    required this.name,
    required this.seatNumber,
    required this.isPaid,
    required this.route,
    this.status,
    this.date,
  });

  // تحويل الكائن إلى نص JSON مشفر للـ QR Code
  String toQrString() {
    return jsonEncode({
      "id": id,
      "name": name,
      "seatNumber": seatNumber,
      "isPaid": isPaid,
      "route": route,
    });
  }

  // هذا المصنع (Factory) هو ما ستستخدمه غداً عند الربط مع الـ API
  factory QrTicketModel.fromJson(Map<String, dynamic> json) {
    return QrTicketModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      seatNumber: json['seatNumber'] ?? '',
      isPaid: json['isPaid'] ?? false,
      route: json['route'] ?? '',
      status: json['status'],
      date: json['date'],
    );
  }
}