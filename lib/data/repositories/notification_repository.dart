import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

import '../../core/services/api_service.dart';
import '../../core/utils/paginated_notifications.dart';
import '../models/notification_model.dart';

import '../providers/notification_provider.dart';



class NotificationRepository {

  final NotificationProvider _provider = NotificationProvider();
  final _box = Hive.box('notifications_box');

  Future<PaginatedNotifications> fetchNotifications({int page = 1}) async {
    try {
      final response = await _provider.getNotifications(page: page);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        int lastPage = response.data['meta']['last_page'] ?? 1;

        List<NotificationModel> notifications = data.map((e) => NotificationModel.fromJson(e)).toList();

        if (page == 1) _saveToCache(notifications);

        return PaginatedNotifications(data: notifications, lastPage: lastPage);
      }
      return PaginatedNotifications(data: _getFromCache(), lastPage: 1);
    } catch (e) {
      return PaginatedNotifications(data: _getFromCache(), lastPage: 1);
    }
  }


  void _saveToCache(List<NotificationModel> notifications) {
    final jsonList = notifications.map((e) => jsonEncode({
      'id': e.id,
      'title': e.title,
      'body': e.body,
      'action_type': e.actionType,
      'reference_type': e.referenceType,
      'reference_id': e.referenceId,
      'created_at': e.createdAt.toIso8601String(),
      'isRead': e.isRead,
      'data': e.data,
    })).toList();

    _box.put('all_notifications', jsonList);
    print("💾 Hive Cache: تم حفظ ${notifications.length} إشعار في الكاش.");
  }

  List<NotificationModel> _getFromCache() {
    final cached = _box.get('all_notifications');

    if (cached == null) {
      print("⚠️ Hive Cache: الكاش فارغ (null).");
      return [];
    }

    print("📂 Hive Cache: تم استرجاع ${cached.length} عنصر من الكاش.");

    return (cached as List).map((e) {
      final map = jsonDecode(e);
      return NotificationModel(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        actionType: map['action_type'],
        referenceType: map['reference_type'] ?? '',
        referenceId: map['reference_id'],
        createdAt: DateTime.parse(map['created_at']),
        data: map['data'] ?? {},
        isRead: map['isRead'],
      );
    }).toList();
  }



  Future<void> markAsRead(String id) async {
    await _provider.markAsRead(id);
  }


  Future<void> markAllAsRead() async {
    final response = await _provider.markAllAsRead();
    if (response.statusCode != 200) {
      throw Exception("Failed to mark all as read");
    }
  }
}
