import 'dart:convert';

class QrTicketModel {
  final String pnr;
  final String name;
  final String phone;
  final List<dynamic> seats;
  final String status;

  QrTicketModel({
    required this.pnr,
    required this.name,
    required this.phone,
    required this.seats,
    required this.status,
  });

  String toQrString() {
    return jsonEncode({
      "pnr": pnr,
      "passenger": {"name": name, "phone": phone},
      "seat_numbers": seats,
      "status": status,
    });
  }
}