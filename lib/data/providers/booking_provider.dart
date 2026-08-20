import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../core/services/api_service.dart';

class BookingProvider {
  final ApiService _apiService = Get.find<ApiService>();


  Future<Response> calculateBooking(Map<String, dynamic> data) async {
    return await _apiService.post(endPoint: 'passenger/bookings/calculate', data: data);
  }

  Future<Response> bookTrip(Map<String, dynamic> bookingData) async {
    return await _apiService.post(endPoint: 'passenger/bookings', data: bookingData);
  }


  Future<Response> getBookings() async {
    return await _apiService.get(endPoint: 'passenger/bookings');
  }

  Future<Response> getBookingDetails(int id) async {
    return await _apiService.get(endPoint: 'passenger/bookings/$id');
  }

  Future<Response> modifyBooking(Map<String, dynamic> data) async {
    return await _apiService.post(endPoint: 'passenger/bookings/modify', data: data);
  }

  Future<Response> payChildBooking(int childBookingId, Map<String, dynamic> data) async {
    return await _apiService.post(
      endPoint: 'passenger/bookings/$childBookingId/pay',
      data: data,
    );
  }

  Future<Response> cancelBooking(int bookingId) async {
    return await _apiService.post(endPoint: 'passenger/bookings/$bookingId/cancel', data: {});
  }
}