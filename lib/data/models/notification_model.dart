class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String actionType;
  final String referenceType;
  final dynamic referenceId;
  // final int referenceId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.actionType,
    required this.referenceType,
    required this.referenceId,
    required this.data,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      actionType: json['action_type'],
      // هنا كان الخطأ، تم تغيير map إلى json
      referenceType: json['reference_type'] ?? '',
      referenceId: json['reference_id'],
      data: json['data'] is Map ? json['data'] : {},
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['read_at'] != null,
    );
  }
}
