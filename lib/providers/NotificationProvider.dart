import 'package:flutter/material.dart';
import '../models/Notification.dart' as my_notif; // Added prefix
import '../models/Notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService;
  List<my_notif.Notification> _notifications = []; // Updated with prefix
  int _unreadCount = 0;

  NotificationProvider(this._notificationService);

  List<my_notif.Notification> get notifications => _notifications; // Updated with prefix
  int get unreadCount => _unreadCount;

  Future<void> loadNotifications(String userId) async {
    _notificationService.streamUserNotifications(userId).listen((notifications) {
      _notifications = notifications;
      _unreadCount = notifications.where((n) => !n.isRead).length;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _notificationService.markAllAsRead(userId);
  }
}