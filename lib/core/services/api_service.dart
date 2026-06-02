import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes/app_routes.dart';
import '../constants/app_color.dart';
import 'package:flutter/material.dart';

import '../shared/custom_snackbar.dart';

class ApiService {
  final Dio _dio;
  bool _isSnackbarOpen = false;
  var isConnected = true.obs;

  ApiService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: "https://syria-travel.app/api/",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': GetStorage().read('lang') ?? 'ar',      },
    ),
  ) {

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final box = GetStorage();
        String? token = box.read('token');

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.message?.contains('SocketException') == true) {

          isConnected.value = false;
          if (!_isSnackbarOpen) {
            _isSnackbarOpen = true;

            Get.snackbar(
              "Network Alert".tr,
              "No internet connection, please check your network and try again.".tr,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
              backgroundColor: AppColor.black.withOpacity(0.9),
              colorText: AppColor.white,
              margin: const EdgeInsets.all(15),
              icon: const Icon(
                Icons.wifi_off_rounded,
                color: AppColor.red,
              ),
              snackbarStatus: (status) {
                if (status == SnackbarStatus.CLOSED) {
                  _isSnackbarOpen = false;
                }
              },
            );
          }
        }

        if (e.response?.statusCode == 401) {
          final box = GetStorage();
          box.remove('token');
          box.remove('user_info');
          box.remove('expiry_date');
          box.write('isLoggedIn', false);

          Get.offAllNamed(AppRoute.login);
        }
        return handler.next(e);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
    ));
  }

  Future<Response> post({
    required String endPoint,
    required dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.post(
      endPoint,
      data: data,
      options: Options(headers: headers),
    );
  }


  Future<bool> checkConnection() async {
    try {
      final Dio testDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));
      await testDio.get("https://www.google.com");
      return true;
    } catch (e) {
      CustomSnackBar.showError("No internet connection, please check your network.");
      isConnected.value = false;
      return false;
    }
  }
  Future<Response> patch({
    required String endPoint,
    dynamic data,
  }) async {
    return await _dio.patch(
      endPoint,
      data: data,
    );
  }

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(
      endPoint,
      queryParameters: queryParameters,
    );
  }
}