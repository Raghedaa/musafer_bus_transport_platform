import '../../core/services/api_service.dart';
import 'package:get/get.dart' hide Response; // 💡 عملنا hide لمنع التعارض مع Response تبع Dio القادم من الـ ApiService
import 'package:dio/dio.dart';

class TripProvider {
  final ApiService _apiService = Get.find<ApiService>();


  Future<Response<dynamic>> searchTrips({
    required String originId,
    required String destinationId,
    required String date,
    required String time,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'origin_city_id': originId,
      'destination_city_id': destinationId,
      'date': date,
      if (time.isNotEmpty) 'time': time,
    };

    return await _apiService.get(
      endPoint: 'trips/search',
      queryParameters: queryParameters,
    );
  }

  // دالة إضافية لجلب الرحلات الشائعة لعرضها بالصفحة بالأساس
  Future<Response<dynamic>> getPopularTrips() async {
    return await _apiService.get(
      endPoint: 'trips/search',
    );
  }


  // أضيفي هذه الدالة داخل كلاس TripProvider
  Future<Response<dynamic>> getCities() async {
    return await _apiService.get(
      endPoint: 'cities',
    );
  }

  // أضيفي هذه الدالة داخل كلاس TripProvider
  Future<Response<dynamic>> getTripDetails(int tripId) async {
    return await _apiService.get(
      endPoint: 'passenger/trips/$tripId',
    );
  }


  Future<Response<dynamic>> getRestAreas() async {
    return await _apiService.get(endPoint: 'rest-areas');
  }

  Future<Response<dynamic>> getStations() async {
    return await _apiService.get(endPoint: 'stations');
  }
}