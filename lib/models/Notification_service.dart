import 'package:cloud_firestore/cloud_firestore.dart';
import 'Notification.dart';
import 'User.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user role with proper null safety
  Future<Role?> _getUserRole(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? Role.values.byName(doc.data()!['role']) : null;
  }

  // Update notification IDs with batch support
  Future<void> _updateUserNotificationIds({
    required String userId,
    required List<String> notificationIds,
    required Role role,
  }) async {
    final collection = role == Role.patient
        ? 'patients'
        : 'healthcareProfessional';
    await _firestore.collection(collection).doc(userId).update({
      'notificationIds': FieldValue.arrayUnion(notificationIds),
    });
  }

  // Stream of notifications (realtime updates)
  Stream<List<Notification>> streamUserNotifications(String userId) {
    return _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => Notification.fromJson(doc.data()))
            .toList());
  }

  // Get unread notifications count (realtime)
  Stream<int> getUnreadCount(String userId) {
    return _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  // Mark all notifications as read (batched)
  Future<void> markAllAsRead(String userId) async {
    final query = await _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Send notification with proper typing
  Future<void> addNotification(Notification notification) async {
    // Validate required fields
    if (notification.userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    // Get user role in a transaction-safe way
    final role = await _getUserRole(notification.userId);
    if (role == null) throw Exception('User not found or role invalid');

    // Create Firestore batch for atomic operations
    final batch = _firestore.batch();

    // 1. Add to notifications collection
    final notificationRef = _firestore.collection('notifications').doc(
        notification.id);
    batch.set(notificationRef, notification.toJson());

    // 2. Update user's notification list
    final userCollection = role == Role.patient
        ? 'patients'
        : 'healthcareProfessional';
    final userRef = _firestore.collection(userCollection).doc(
        notification.userId);
    batch.update(userRef, {
      'notificationIds': FieldValue.arrayUnion([notification.id]),
      'lastNotificationTime': FieldValue.serverTimestamp(),
      // Optional: track last notification time
    });

    // Execute transaction
    await batch.commit();
  }


  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? payload,
  }) async {
    final notification = Notification(
      id: _firestore
          .collection('notifications')
          .doc()
          .id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      payload: payload,
    );

    await addNotification(notification);
  }

}