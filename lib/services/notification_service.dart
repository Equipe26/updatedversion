import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Flutter Local Notifications plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification settings keys
  static const String _generalNotificationsKey = 'general_notifications';
  static const String _soundKey = 'notification_sound';
  static const String _vibrateKey = 'notification_vibrate';

  // Initialize notification settings
  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization (not needed as per requirements but included for completeness)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // General initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification taps here
      },
    );

    // Request notifications permission
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Load all notification preferences
  Future<Map<String, bool>> loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Default values if preferences don't exist yet
    final bool generalNotifications = prefs.getBool(_generalNotificationsKey) ?? true;
    final bool sound = prefs.getBool(_soundKey) ?? true;
    final bool vibrate = prefs.getBool(_vibrateKey) ?? false;

    return {
      _generalNotificationsKey: generalNotifications,
      _soundKey: sound,
      _vibrateKey: vibrate,
    };
  }

  // Save general notification setting
  Future<void> setGeneralNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_generalNotificationsKey, value);
  }

  // Save sound notification setting
  Future<void> setSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);
  }

  // Save vibration notification setting
  Future<void> setVibration(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrateKey, value);
  }

  // Show a notification respecting the user's settings
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Load notification preferences
    final prefs = await loadNotificationPreferences();
    final bool generalNotificationsEnabled = prefs[_generalNotificationsKey]!;
    
    // Don't show notifications if disabled
    if (!generalNotificationsEnabled) return;
    
    // Configure Android notification details based on user preferences
    final bool soundEnabled = prefs[_soundKey]!;
    final bool vibrateEnabled = prefs[_vibrateKey]!;

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chifaa_channel',
      'Chifaa Notifications',
      channelDescription: 'Main notification channel for Chifaa app',
      importance: Importance.max,
      priority: Priority.high,
      playSound: soundEnabled,
      enableVibration: vibrateEnabled,
      // Use default vibration pattern if enabled
      vibrationPattern: vibrateEnabled
          ? Int64List.fromList([0, 500, 200, 500])
          : null,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Load notification preferences
    final prefs = await loadNotificationPreferences();
    final bool generalNotificationsEnabled = prefs[_generalNotificationsKey]!;
    
    // Don't schedule notification if disabled
    if (!generalNotificationsEnabled) return;

    // Configure Android notification details based on user preferences
    final bool soundEnabled = prefs[_soundKey]!;
    final bool vibrateEnabled = prefs[_vibrateKey]!;

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chifaa_scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Channel for scheduled notifications like appointment reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: soundEnabled,
      enableVibration: vibrateEnabled,
      // Use default vibration pattern if enabled
      vibrationPattern: vibrateEnabled
          ? Int64List.fromList([0, 500, 200, 500])
          : null,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
