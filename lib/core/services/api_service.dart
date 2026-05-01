import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response; // استخدام hide لتجنب التعارض مع Dio
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes/app_routes.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: "https://syria-travel.app/api/",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {

    // إضافة Interceptor للتحكم التلقائي بالتوكن والأخطاء
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // قراءة التوكن المحفوظ
        final box = GetStorage();
        String? token = box.read('token');

        // إذا التوكن موجود، ضيفه للهيدر تلقائياً
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          print("Interceptor: Adding Token to Header"); // English Log
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // إذا السيرفر رجع 401 يعني التوكن انتهى أو غير صالح
        if (e.response?.statusCode == 401) {
          print("Interceptor: Unauthorized! Clearing session..."); // English Log

          final box = GetStorage();
          box.remove('token'); // حذف التوكن
          box.write('isLoggedIn', false);

          Get.offAllNamed(AppRoute.login); // إعادة المستخدم لصفحة تسجيل الدخول
        }
        return handler.next(e);
      },
    ));

    // لإظهار تفاصيل الطلبات في الـ Console (مفيد جداً أثناء التطوير)
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
    ));
  }

  // دالة الـ POST (لاحظي حذفنا بارامتر التوكن لأنه صار ينضاف تلقائياً)
  Future<Response> post({
    required String endPoint,
    required dynamic data,
  }) async {
    return await _dio.post(
      endPoint,
      data: data,
    );
  }

  // دالة الـ GET
  Future<Response> get({required String endPoint}) async {
    return await _dio.get(
      endPoint,
    );
  }
}