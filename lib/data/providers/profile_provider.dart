import 'package:dio/src/response.dart';
import 'package:get/get_connect/http/src/response/response.dart' hide Response;
import '../../core/services/api_service.dart';

class ProfileProvider {
  final ApiService _apiService = ApiService();

  Future<Response> getProfile() async => await _apiService.get(endPoint: 'passenger/profile');

  Future<Response> updateProfile(Map<String, dynamic> data) async =>
      await _apiService.patch(endPoint: 'passenger/profile', data: data);

Future<Response> topUpWallet(Map<String, dynamic> data) async =>
    await _apiService.post(endPoint: 'passenger/wallet/top-up', data: data);
}