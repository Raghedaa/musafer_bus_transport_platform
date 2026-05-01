import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../providers/auth_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider;

  AuthRepository(this._authProvider);

  Future<Either<String, dynamic>> sendLoginOtp(String phone) async {
    try {
      final response = await _authProvider.sendOtp(phone);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Failed to send OTP");
    }
  }

  Future<Either<String, dynamic>> loginVerify(String phone, String code) async {
    try {
      final response = await _authProvider.loginConfirm(phone, code);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Login failed");
    }
  }

  Future<Either<String, dynamic>> registerRequest({required String name, required String phone ,required String gender,}) async {
    try {
      final response = await _authProvider.register(name, phone,gender);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Registration failed");
    }
  }

  Future<Either<String, dynamic>> registerVerify(String phone, String code) async {
    try {
      final response = await _authProvider.verifyRegister(phone, code);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Verification failed");
    }
  }
}