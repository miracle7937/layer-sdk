import 'dart:async';
import 'dart:convert';

import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A callback to handle the notification activity.
typedef NotificationActivityHandler = void Function(
  String activityQuery,
  String customerId,
);

/// The FirebaseMessaging notification widget.
///
/// We use the [FirebaseMessaging] package on both Frontend and Backend for
/// sending app notificiations to the user when certain events ocurr.
///
/// When a user receives a notification on its device and presses it, the
/// firebase messaging plugin callbacks gets triggered and we use the passed
/// [openActivity] callback for notifying the app that the user has pressed
/// a notification. A [activityQuery] and a [customerId] parameters get
/// passed through the callback so the app can decide which flow will open.
///
/// Since this is an external pluggin, there might be some steps to follow
/// before firebase messaging is functional on your app, please make sure
/// that you read the [instalation notes](https://firebase.flutter.dev/docs/messaging/overview/#installation)
/// so the plugin works as it is expected.
///
/// A [child] widget is required, so this widget is usually used along with the
/// [HomeScreen] widget.
///
/// {@tool snippet}
/// ```dart
/// FirebaseNotification(
///   openActivity: (activityQuery, customerId){
///     /// Decide which flow should be opened for the activityQuery and
///     /// customerId.
///   },
///   child: HomeScreen(),
/// );
/// ```
/// {@end-tool}
class FirebaseNotification extends StatefulWidget {
  /// Child widget.
  final Widget child;

  /// A callback that will be called when user selects a notification.
  ///
  /// `activityQuery` and `customerId` parameters can be used to present
  /// a specific screen to the user.
  final NotificationActivityHandler openActivity;

  /// Creates FirebaseNotification widget.
  const FirebaseNotification({
    Key? key,
    required this.child,
    required this.openActivity,
  }) : super(key: key);

  @override
  _FirebaseNotificationState createState() => _FirebaseNotificationState();
}

class _FirebaseNotificationState extends State<FirebaseNotification> {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  void _load() async {
    await _initFirebase();
    await _initLocalNotifications();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(showLocalNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _handleNotification(message.data),
      );
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleNotification(initialMessage.data);
      }
    }
  }

  void showLocalNotification(RemoteMessage? message) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'default_notification_channel_id',
      'default_notification_channel_id',
      importance: Importance.high,
      priority: Priority.max,
      ticker: 'ticker',
      color: DesignSystem.of(context).brandPrimary,
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message?.notification?.title,
      message?.notification?.body,
      platformChannelSpecifics,
      payload: json.encode(message?.data),
    );
  }

  Future<void> _initLocalNotifications() async {
    final androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_notification');

    final iOSInitializationSettings = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    await _checkNotifications();
  }

  Future<void> _checkNotifications() async {
    final result =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (!(result?.didNotificationLaunchApp ?? false)) return;

    final payload = result?.payload;
    if (payload == null) return;

    final decoded = jsonDecode(payload);
    _handleNotification(decoded);
  }

  void _handleNotification(Map<String, dynamic> message) async {
    var data = message;

    var activityQuery = data['activity_query'];
    if (activityQuery == null) {
      final alertInfo = data['alert_info'];
      activityQuery =
          alertInfo != null ? json.decode(alertInfo)['activity_query'] : null;
    }
    final customerId = data['customer_id'];

    widget.openActivity(activityQuery, customerId);
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      final message = json.decode(payload);
      _handleNotification(message);
    }
  }

  Future<void> onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {}

  @override
  Widget build(BuildContext context) => widget.child;
}
