import 'package:dio/src/response.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/connect.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';

import '../../core/services/api_service.dart';

class TrackingProvider extends GetConnect {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Response> submitReviewBatch(Map<String, dynamic> data) async {
  return await _apiService.post(endPoint: 'passenger/reviews/batch', data: data);

  }
}