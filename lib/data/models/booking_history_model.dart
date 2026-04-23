class BookingModel {
  final String id;
  final String status;
  final String pnr;
  final String fromCity;
  final String fromStation;
  final String toCity;
  final String toStation;
  final String dateTime;

  BookingModel({
    required this.id,
    required this.status,
    required this.pnr,
    required this.fromCity,
    required this.fromStation,
    required this.toCity,
    required this.toStation,
    required this.dateTime,
  });
}