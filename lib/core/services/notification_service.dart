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
        // تمرير true لأن التطبيق مفتوح ومضغوط من الداخل أو الخلفية
        _navigateToNotifications(isFromTerminated: false);
      },
    );

    String? token = await messaging.getToken();
    debugPrint("Firebase Token: $token");
    if (token != null) {
      await sendTokenToServer(token);
    }

    messaging.onTokenRefresh.listen((newToken) {
      sendTokenToServer(newToken);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          _navigateToNotifications(isFromTerminated: true);
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNotifications(isFromTerminated: false);
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

  static void _navigateToNotifications({required bool isFromTerminated}) {
    if (!Get.isRegistered<NotificationController>()) {
      Get.put(NotificationController());
    }

    if (isFromTerminated) {
      Get.to(() => NotificationScreen());
    } else {
      if (Get.currentRoute != '/main-layout' &&
          Get.currentRoute != '/MainLayoutScreen') {
        Get.offAllNamed('/main-layout');
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.to(() => NotificationScreen());
        });
      } else {
        if (Get.currentRoute != '/NotificationScreen') {
          Get.to(() => NotificationScreen());
        }
      }
    }
  }


  static Future<void> sendTokenToServer(String token) async {
    try {
      final api = Get.find<ApiService>();
      final box = GetStorage();
      String currentLang = box.read('lang') ?? 'ar';

      await api.post(
        endPoint: 'auth/fcm-token',
        data: {
          "token": token,
          "platform": "android",
          "lang": currentLang,
        },
      );
    } catch (e) {
      debugPrint("❌ FCM Token send failed: $e");
    }
  }
}