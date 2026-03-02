import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      onDidReceiveNotificationResponse: (details) {
        print('Notification clicked!');
      },
      settings: settings,
    );

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("84606a32-81cc-4da7-8915-12aaece316e3");
    OneSignal.Notifications.requestPermission(false);
    OneSignal.Notifications.addClickListener((event) {
      print('OneSignal notification clicked: $event');
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault(); // Stop OneSignal from showing its own UI
      showNotification(
        title: event.notification.title,
        body: event.notification.body ?? 'New notification',
      );
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String body = 'This is a notification',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'basic_id',
      'basic',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      payload: "",
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }
}
