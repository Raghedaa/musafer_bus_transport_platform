import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class AuthProvider {
  final ApiService _apiService;

  AuthProvider(this._apiService);

  Future<Response> sendOtp(String phone) async {
    return await _apiService.post(
      endPoint: 'auth/otp/send',
      data: {
        "phone_number": phone,
        "intent": "passenger",
      },
    );
  }

  Future<Response> loginConfirm(String phone, String code) async {
    return await _apiService.post(
      endPoint: 'auth/otp/login',
      data: {
        "phone_number": phone,
        "code": code,
        "intent": "passenger",
      },
    );
  }

  Future<Response> register(String name, String phone ,String gender) async {
    return await _apiService.post(
      endPoint: 'auth/otp/register',
      data: {
        "name": name,
        "gender": gender,
        "phone_number": phone,
        "intent": "passenger",
      },
    );
  }

  Future<Response> verifyRegister(String phone, String code) async {
    return await _apiService.post(
      endPoint: 'auth/otp/verify',
      data: {
        "phone_number": phone,
        "code": code,
        "intent": "passenger",
      },
    );
  }
}