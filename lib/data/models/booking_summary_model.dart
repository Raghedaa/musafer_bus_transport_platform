import 'trip_model.dart';

class BookingSummaryModel {
  final TripModel tripDetails;
  final List<String> selectedSeats;
  final String pnrNumber;
  final double totalPrice;
  final DateTime bookingDate;


  BookingSummaryModel({
    required this.tripDetails,
    required this.selectedSeats,
    required this.pnrNumber,
    required this.totalPrice,
    required this.bookingDate,
  });
}