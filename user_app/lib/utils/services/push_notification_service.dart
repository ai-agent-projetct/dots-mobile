import 'dart:async';
import 'dart:convert';
import 'package:universal_io/io.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user/config/app_routes.dart';
import 'package:user/firebase_options.dart';
import 'package:user/main.dart';
import 'package:user/utils/services/prefs.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
  'dots_user_notification',
  'Dots user channel',
  importance: Importance.max,
);

class PushNotificationService {
  late Stream<String> _tokenStream;

  PushNotificationService();
  Future<void> setupNotification() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      try {
        String? token = await FirebaseMessaging.instance.getToken();
        _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
        if (token == null) {
          // Token may be null if the server is unable to generate it
          // or if the app hasn't been configured with FCM correctly.
          debugPrint('Unable to retrieve FCM token.');
        } else {
          await setFCMToken(token);
        }
        _tokenStream.listen(setFCMToken);
      } catch (e) {
        debugPrint('catch error for fcm token ----> ${e.toString()}');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      // User denied permission to receive notifications.
      debugPrint('User denied permission to receive notifications.');
    }
    await forgroundMessage();
    await initPushNotification();
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future initPushNotification() async {
    // Just handling the notification when App is in background
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNavigation(message);
    });

    // Called when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        didReceiveLocalNotificationStream.add('refresh');
        debugPrint('notification onmessage listen ${message.toMap()}');
      }
      if (Platform.isIOS) {
        forgroundMessage();
        showNotification(message);
      }
      if (Platform.isAndroid) {
        await initLocalNotification();
        showNotification(message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          androidChannel.id.toString(),
          androidChannel.name.toString(),
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'slow_spring_board.aiff',
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    if (message.notification != null) {
      Future.delayed(Duration.zero, () {
        localNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: jsonEncode(message.data),
        );
      });
    }
  }

  Future initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          Navigator.pushNamed(
            navigatorKey.currentState!.context,
            AppRoutes.bottomNavigation,
          );
        }
      },
    );
  }

  setFCMToken(String? token) async {
    debugPrint('FCM Token: $token');
    await Prefs().setString(Prefs.fcmToken, token.toString());
  }
}

handleNavigation(RemoteMessage message) async {
  Navigator.pushNamed(
    navigatorKey.currentState!.context,
    AppRoutes.bottomNavigation,
  );
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('notification background try');
    didReceiveLocalNotificationStream.add('refresh');
  } catch (e) {
    debugPrint('notification background catch: $e');
  }
}
