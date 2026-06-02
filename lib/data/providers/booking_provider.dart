import 'package:dio/dio.dart'; // استخدمي Dio لضمان التوافق
import 'package:get/get.dart' hide Response; // اخفي Response الخاصة بـ Get
import '../../core/services/api_service.dart';

class BookingProvider {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Response> bookTrip(Map<String, dynamic> bookingData) async {
    return await _apiService.post(endPoint: 'passenger/bookings', data: bookingData);
  }

  Future<Response> getBookings() async {
    return await _apiService.get(endPoint: 'passenger/bookings');
  }

  Future<Response> getBookingDetails(int id) async {
    return await _apiService.get(endPoint: 'passenger/bookings/$id');
  }

}