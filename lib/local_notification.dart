import 'package:basic_flutter/main.dart';
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
        _handleNavigation(details.payload);
      },
      settings: settings,
    );

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("84606a32-81cc-4da7-8915-12aaece316e3");
    OneSignal.Notifications.requestPermission(false);
    OneSignal.Notifications.addClickListener((event) {
      print('OneSignal notification clicked: $event');
    });

    OneSignal.Notifications.addClickListener((event) {
      final screen = event.notification.additionalData?['screen'] as String?;
      final id = event.notification.additionalData?['id'] as String?;
      _handleNavigation(screen, arguments: id);
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault(); // Stop OneSignal from showing its own UI
      final screen = event.notification.additionalData?['screen'] as String?;
      showNotification(
        payLoad: screen,
        title: event.notification.title,
        body: event.notification.body ?? 'New notification',
      );
    });
  }

  static void _handleNavigation(String? screen, {String? arguments}) {
    if (screen == null) return;

    navigatorKey.currentState?.pushNamed(screen, arguments: arguments);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? payLoad,
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
      payload: payLoad,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }
}
