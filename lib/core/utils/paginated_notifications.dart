import '../../data/models/notification_model.dart';

class PaginatedNotifications {
  final List<NotificationModel> data;
  final int lastPage;

  PaginatedNotifications({required this.data, required this.lastPage});
}