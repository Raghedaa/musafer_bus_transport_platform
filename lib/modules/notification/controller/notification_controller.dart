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
import '../../complaints/controllers/my_complaints_controller.dart';
import '../../complaints/views/screen/my_complaints_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../../my_subscriptions/binding/my_subscriptions_binding.dart';
import '../../my_subscriptions/controllers/my_subscriptions_controller.dart';
import '../../my_subscriptions/view/screen/my_subscriptions_screen.dart';
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
    // 1. التحديث المحلي السريع
    markAsRead(notification);

    String action = notification.actionType.trim();
    debugPrint("🟢 Tapped Notification Action: $action");

    switch (action) {
   case 'view_booking':
        print('🔵 [view_booking] START');

        final bodyParams = notification.data['body_params'];
        if (bodyParams != null && bodyParams['trip_id'] != null) {
          final int tripId = int.parse(bodyParams['trip_id'].toString());

          // ✅ إغلاق صفحة الإشعارات بالقوة
          print('🔵 [view_booking] Closing notification page...');
          try {
            Get.close(1); // إغلاق الصفحة الحالية
          } catch (e) {
            print('🔵 [view_booking] Error closing page: $e');
          }

          // ✅ إضافة تأخير صغير للتأكد من إغلاق الصفحة
          Future.delayed(const Duration(milliseconds: 100), () {
            print('🔵 [view_booking] Navigating to bookings...');
            final mainLayout = Get.find<MainLayoutController>();
            mainLayout.resetAndGoToBookings();

            // ✅ التأكد من التغيير
            mainLayout.currentIndex.value = 0;
            mainLayout.update();

            print('🔵 [view_booking] Current index: ${mainLayout.currentIndex.value}');

            // ✅ جلب البيانات وتحديد الـ Highlight
            Future.delayed(const Duration(milliseconds: 300), () async {
              print('🔵 [view_booking] Fetching bookings for highlight...');
              final bookingCtrl = Get.isRegistered<BookingHistoryController>()
                  ? Get.find<BookingHistoryController>()
                  : Get.put(BookingHistoryController());

              bookingCtrl.changeFilter("All");
              await bookingCtrl.fetchBookings();

              var matchingBooking = bookingCtrl.allBookings.firstWhereOrNull(
                      (b) => b.tripId == tripId);

              if (matchingBooking != null) {
                print('🔵 [view_booking] Found booking ID: ${matchingBooking.id}');
                bookingCtrl.setHighlightedId(matchingBooking.id);
              } else {
                print('🔵 [view_booking] No matching booking found for tripId: $tripId');
              }
            });
          });
        }
        break;

      case 'view_complaint':
        if (Get.isOverlaysOpen) Get.back();
        Get.back();

        final mainLayout = Get.find<MainLayoutController>();
        final complaintIdData = notification.data['complaint_id'];

        final complaintsCtrl = Get.isRegistered<MyComplaintsController>()
            ? Get.find<MyComplaintsController>()
            : Get.put(MyComplaintsController());

        Get.to(() => const MyComplaintsScreen());

        mainLayout.currentIndex.value = 4;
        mainLayout.resetStack(4);

        if (complaintsCtrl.complaints.isEmpty) {
          complaintsCtrl.fetchComplaints().then((_) {
            if (complaintIdData != null) {
              final int complaintId = int.parse(complaintIdData.toString());
              complaintsCtrl.setHighlightedId(complaintId);
            }
          });
        } else {
          if (complaintIdData != null) {
            final int complaintId = int.parse(complaintIdData.toString());
            complaintsCtrl.setHighlightedId(complaintId);
          }
        }
        break;
      case 'view_subscription':
        if (Get.isOverlaysOpen) Get.back();
        Get.back();

        final mainLayout = Get.find<MainLayoutController>();
        final subIdData = notification.data['subscription_id'];

        final subCtrl = Get.isRegistered<MySubscriptionsController>()
            ? Get.find<MySubscriptionsController>()
            : Get.put(MySubscriptionsController());

        Get.to(() => const MySubscriptionsScreen());

        mainLayout.currentIndex.value = 1;
        mainLayout.resetStack(1);

        if (subCtrl.subscriptions.isEmpty) {
          subCtrl.fetchMySubscriptions().then((_) {
            if (subIdData != null) {
              final int subId = int.parse(subIdData.toString());
              subCtrl.setHighlightedId(subId);
            }
          });
        } else {
          if (subIdData != null) {
            final int subId = int.parse(subIdData.toString());
            subCtrl.setHighlightedId(subId);
          }
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