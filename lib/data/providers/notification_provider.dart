import 'package:dio/src/response.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/http/src/response/response.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';

import '../../core/services/api_service.dart';

class NotificationProvider {

  final ApiService _api = Get.find<ApiService>();



  Future<Response> getNotifications({int page = 1}) =>
      _api.get(endPoint: 'notifications?page=$page');

  Future<Response> getUnreadCount() => _api.get(endPoint: 'notifications/unread-count');

  Future<Response> markAsRead(String id) => _api.patch(endPoint: 'notifications/$id/mark', data: {});

  Future<Response> markAllAsRead() => _api.patch(endPoint: 'notifications/mark-all', data: {});

}