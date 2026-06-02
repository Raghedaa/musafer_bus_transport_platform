import 'package:dio/src/response.dart';
import 'package:get/get_connect/http/src/response/response.dart' as dio;
import '../../core/services/api_service.dart';


class PromoProvider {
  final ApiService _apiService = ApiService();

  Future<Response> fetchPromoCodes() async {
    return await _apiService.get(endPoint: 'passenger/promo-codes');
  }


  Future<Response> validatePromoCode(String code, int tripId) async {
    return await _apiService.post(
      endPoint: 'passenger/promo-codes/validate',
      data: {
        'promo_code': code,
        'trip_id': tripId,
      },
    );
  }

}