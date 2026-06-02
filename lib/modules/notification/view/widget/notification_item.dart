import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/management_tile.dart'; // تأكدي من المسار
import '../../../../data/models/notification_model.dart';
import '../../controller/notification_controller.dart';

class NotificationItem extends GetView<NotificationController> {
  final NotificationModel notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // جلب الوقت من الريسبونس وتحويله لصيغة (منذ 40 دقيقة)
    final String timeAgo = timeago.format(notification.createdAt, locale: Get.locale?.languageCode ?? 'ar');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: ManagementTile(
        title: notification.title,
        subtitle: "${notification.body}\n$timeAgo", // عرض الجسم مع الوقت تحت بعض
        icon:Icons.notifications,
        iconColor: AppColor.darkgreen,
        iconBgColor: AppColor.darkgreen.withOpacity(0.1),

        // النقطة الخضراء في جهة اليمين (trailing) إذا كان غير مقروء
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!notification.isRead)
              Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  color: AppColor.darkgreen, // النقطة الخضراء
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(width: 8.w),
            // Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
          ],
        ),

        // تمييز الكارد غير المقروء بحدود خضراء خفيفة وخلفية زرقاء خفيفة جداً
        borderColor: notification.isRead ? Colors.transparent : AppColor.darkgreen.withOpacity(0.3),
        bgColor: notification.isRead ? Colors.white : AppColor.darkgreen.withOpacity(0.02),

        // onTap: () => controller.markAsRead(notification), // الربط مع API
// في ملف NotificationItem.dart

        onTap: () => controller.handleNotificationTap(notification),
      ),
    );
  }
}