import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/api_service.dart';
import '../../modules/notification/controller/notification_controller.dart';
import '../../modules/notification/view/screen/notification_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _navigateToNotifications();
      },
    );

    String? token = await messaging.getToken();
    debugPrint("Firebase Token: $token");
    if (token != null) {
      await _sendTokenToServer(token);
    }

    messaging.onTokenRefresh.listen((newToken) {
      _sendTokenToServer(newToken);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _navigateToNotifications();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNotifications();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().fetchNotifications();
      }

      if (notification != null && android != null) {
        _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: 'Musafer Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  static void _navigateToNotifications() {
    if (Get.currentRoute != '/NotificationScreen') {
      if (!Get.isRegistered<NotificationController>()) {
        Get.put(NotificationController());
      }
      Get.to(() => NotificationScreen());
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    try {
      final api = Get.find<ApiService>();
      await api.post(
        endPoint: 'auth/fcm-token',
        data: {"token": token, "platform": "android"},
      );
    } catch (e) {
      debugPrint("❌ FCM Token send failed: $e");
    }
  }
}