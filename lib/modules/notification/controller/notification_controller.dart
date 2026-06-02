import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musafer/modules/booking_summary/view/screen/booking_summary_screen.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../routes/app_routes/app_routes.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../booking_history/view/screen/booking_history_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../../profile/view/screen/profile_view.dart';
import '../../settings/view/screen/settings_view.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../../ticket_details/view/screen/ticket_details_screen.dart';
import '../../trip_details/controllers/trip_details_controller.dart';
import '../../trip_details/view/screen/trip_details_screen.dart';



class NotificationController extends GetxController {
  final NotificationRepository _repository = NotificationRepository();
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = true.obs;
  var isMoreLoading = false.obs;
  int currentPage = 1;
  int lastPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      fetchNotifications();
    });
  }


  Future<void> handleNotificationTap(NotificationModel notification) async {
    // 1. لا ننتظر الـ API ليخلص، نقوم بعمل التعديل محلياً فوراً للتسريع
    markAsRead(notification);

    final mainLayoutController = Get.find<MainLayoutController>();

    String action = notification.actionType.trim();

    debugPrint("🟢 Tapped Notification Action: $action");

    switch (action) {
      case 'trip_assigned':
      // ... كود الرحلة
        break;

      case 'booking_confirmed':
      // ... كود الحجز
        break;

      case 'trip_status_changed':
        final tripIdData = notification.data['trip_id'];
        if (tripIdData != null) {
          final int tripId = int.parse(tripIdData.toString());
          final mainLayout = Get.find<MainLayoutController>();

          mainLayout.currentIndex.value = 0;

          mainLayout.notificationStack.clear();
          mainLayout.notificationStack.add(const SettingsView());

          mainLayout.resetAndGoToBookings();

          mainLayout.notificationStack.assignAll([const ProfileView()]);
          mainLayout.profileStack.assignAll([const ProfileView()]);
          // 4. تفعيل الهايلايت
          Future.delayed(const Duration(milliseconds: 800), () {
            if (Get.isRegistered<BookingHistoryController>()) {
              final bookingCtrl = Get.find<BookingHistoryController>();
              final matchingBooking = bookingCtrl.allBookings.firstWhereOrNull((b) => b.tripId == tripId);

              if (matchingBooking != null) {
                bookingCtrl.setHighlightedId(matchingBooking.id);
              } else {
                bookingCtrl.fetchBookings().then((_) {
                  final reCheck = bookingCtrl.allBookings.firstWhereOrNull((b) => b.tripId == tripId);
                  if (reCheck != null) bookingCtrl.setHighlightedId(reCheck.id);
                });
              }
            }
          });
        }
        break;
    }
  }




  Future<void> fetchNotifications({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (currentPage >= lastPage) return;
      isMoreLoading.value = true;
      currentPage++;
    } else {
      isLoading.value = true;
      currentPage = 1;
    }

    try {
      final result = await _repository.fetchNotifications(page: currentPage);

      if (isLoadMore) {
        notifications.addAll(result.data);
      } else {
        notifications.assignAll(result.data);
        lastPage = result.lastPage;
      }
      _updateUnreadCount();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;
    try {
      notification.isRead = true;
      notifications.refresh();
      _updateUnreadCount();
      await _repository.markAsRead(notification.id);
    } catch (e) {
      print("API Error: $e");
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0) return;
    try {
      for (var n in notifications) { n.isRead = true; }
      notifications.refresh();
      _updateUnreadCount();

      await _repository.markAllAsRead();
      Get.snackbar("success".tr, "all_marked_read".tr);
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
    }
  }


  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }
}