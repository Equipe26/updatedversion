import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/common/messages/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/Notification.dart' as my_notif; // Added prefix
import '../../../providers/NotificationProvider.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {                                  
  // Handle case where user is not logged in
  return Scaffold(body: Center(child: Text('Please log in')));
}
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    // Load notifications when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationProvider.loadNotifications(currentUserId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Color(0xFF073057)),
            const SizedBox(width: 8),
            Text(
              'Notifications',
              style: GoogleFonts.leagueSpartan(
                fontSize: 22, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF073057),
              ),
            ),
            Consumer<NotificationProvider>(
              builder: (context, provider, child) {
                return provider.unreadCount > 0
                  ? Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        provider.unreadCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.notifications.isEmpty) {
            return Center(child: Text('No notifications yet'));
          }

          return Container(
            color: const Color(0xFFE7ECFB),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Aujourd'hui",
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => provider.markAllAsRead(currentUserId),
                        child: Text(
                          "Marquer les comme lus",
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold, 
                            color: const Color(0xFF396C9B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Notification List
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = provider.notifications[index];
                        return _buildNotificationItem(
                          notification: notification,
                          onTap: () {
                            provider.markAsRead(notification.id);
                            // Handle notification tap (navigate to relevant screen)
                            _handleNotificationTap(context, notification);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required my_notif.Notification notification, // Updated with prefix
    required VoidCallback onTap,
  }) {
    final icon = _getIconForType(notification.type);
    final time = _formatTime(notification.createdAt);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Color(0xFFE7F2FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: notification.isRead ? Colors.transparent : Color(0xFFA3C3E4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF396C9B)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12, 
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 14, 
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(my_notif.NotificationType type) { // Updated with prefix
    switch (type) {
      case my_notif.NotificationType.appointmentReminder:
      case my_notif.NotificationType.appointmentConfirmation:
      case my_notif.NotificationType.appointmentCancellation:
        return Icons.event;
      case my_notif.NotificationType.systemAlert:
        return Icons.system_update;
      case my_notif.NotificationType.newMessage:
        return Icons.message;
      case my_notif.NotificationType.ratingReminder:
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Maintenant';
    }
  }

  void _handleNotificationTap(BuildContext context, my_notif.Notification notification) { // Updated with prefix
    // Handle navigation based on notification type
    switch (notification.type) {
      case my_notif.NotificationType.newMessage:
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            connectionId: notification.payload?['connectionId'] ?? '',
            conversationId: notification.payload?['conversationId'] ?? '',
            otherParticipant: {
              'id': notification.payload?['senderId'] ?? '',
              'name': notification.payload?['senderName'] ?? 'Doctor',
              // Ajoutez d'autres champs si nécessaires
            },
          ),
        ),
      );
        break;
      // Add other cases as needed
      default:
        break;
    }
  }

  Widget _buildDateLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.leagueSpartan(
            fontSize: 16, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}