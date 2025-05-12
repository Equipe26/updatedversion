import 'dart:io';
import 'package:flutter/material.dart' hide Notification;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database_service.dart';
import 'Connection.dart';
import 'Conversation.dart';
import 'MedicalDocument.dart';
import 'MedicalDocumentService.dart';
import 'Message.dart';
import 'Notification.dart' as MyNotification;
import 'Notification_service.dart';

class MessagingService {
  final FirestoreService<Conversation> _conversationDb;
  final FirestoreService<Message> _messageDb;
  final FirestoreService<Connection> _connectionDb;
  final MedicalDocumentService _documentService;
  final NotificationService _notificationService;
  final SupabaseClient _supabase;

  MessagingService()
      : _conversationDb = FirestoreService<Conversation>(
          collectionPath: 'conversations',
          fromJson: Conversation.fromJson,
          toJson: (c) => c.toJson(),
        ),
        _messageDb = FirestoreService<Message>(
          collectionPath: 'messages',
          fromJson: Message.fromJson,
          toJson: (m) => m.toJson(),
        ),
        _connectionDb = FirestoreService<Connection>(
          collectionPath: 'connections',
          fromJson: Connection.fromJson,
          toJson: (c) => c.toJson(),
        ),
        _documentService = MedicalDocumentService(),
        _notificationService = NotificationService(),
        _supabase = Supabase.instance.client;

  // Conversation management
  Future<String> createConversation(String connectionId, [String? id]) async {
    try {
      final conversation = Conversation(
        id: id ?? 'conv_${DateTime.now().millisecondsSinceEpoch}',
        connectionId: connectionId,
        messageIds: [],
        lastMessageTimestamp: DateTime.now(),
      );
      await _conversationDb.add(data: conversation, id: conversation.id);
      return conversation.id;
    } catch (e) {
      debugPrint('Error creating conversation: $e');
      rethrow;
    }
  }

  Stream<List<Conversation>> getUserConversations(String userId) {
    try {
      return _connectionDb.collectionRef
          .where('patientId', isEqualTo: userId)
          .snapshots()
          .asyncExpand((patientConnections) async* {
            final professionalConnections = await _connectionDb.collectionRef
                .where('healthcareProfessionalId', isEqualTo: userId)
                .get();

            final allConnectionIds = [
              ...patientConnections.docs.map((doc) => doc.id),
              ...professionalConnections.docs.map((doc) => doc.id),
            ];

            if (allConnectionIds.isEmpty) {
              yield [];
              return;
            }

            yield* _conversationDb.collectionRef
                .where('connectionId', whereIn: allConnectionIds)
                .snapshots()
                .map((snapshot) {
                  final conversations = snapshot.docs
                      .map((doc) => doc.data())
                      .whereType<Conversation>()
                      .toList();
                  conversations.sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
                  return conversations;
                });
          });
    } catch (e) {
      debugPrint('Error getting user conversations: $e');
      return Stream.error(e);
    }
  }

  Future<Conversation?> _getConversation(String conversationId) async {
    try {
      return await _conversationDb.get(conversationId);
    } catch (e) {
      debugPrint('Error getting conversation: $e');
      return null;
    }
  }

  // Message management
  Future<void> sendMessage({
    required String connectionId,
    required String conversationId,
    required String senderId,
    required String recipientId,
    required String content,
    List<String>? attachmentIds,
    bool sendNotification = true,
  }) async {
    debugPrint('[MessagingService] Starting sendMessage process');
    debugPrint('[MessagingService] Parameters:');
    debugPrint('  - connectionId: $connectionId');
    debugPrint('  - conversationId: $conversationId');
    debugPrint('  - senderId: $senderId');
    debugPrint('  - recipientId: $recipientId');
    debugPrint('  - content: ${content.length > 50 ? content.substring(0, 50) + "..." : content}');
    debugPrint('  - hasAttachments: ${attachmentIds?.isNotEmpty ?? false}');

    try {
      // 1. Get or create conversation
      Conversation conversation;
      final existingConv = await _getConversation(conversationId);
      
      if (existingConv == null) {
        debugPrint('[MessagingService] Conversation not found, creating new one...');
        conversation = Conversation(
          id: conversationId,
          connectionId: connectionId,
          messageIds: [],
          lastMessageTimestamp: DateTime.now(),
        );
        await _conversationDb.add(data: conversation, id: conversation.id);
        debugPrint('[MessagingService] New conversation created with ID: ${conversation.id}');
      } else {
        conversation = existingConv;
        debugPrint('[MessagingService] Found conversation: ${conversation.id}');
      }

      // 2. Create and save message
      debugPrint('[MessagingService] Creating message...');
      final messageId = _messageDb.collectionRef.doc().id;
      debugPrint('[MessagingService] Generated message ID: $messageId');
      
      final message = Message(
        id: messageId,
        conversationId: conversationId,
        senderId: senderId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
        attachmentIds: attachmentIds ?? [],
      );

      debugPrint('[MessagingService] Saving message to database...');
      await _messageDb.add(data: message, id: messageId);
      debugPrint('[MessagingService] Message saved successfully');

      // 3. Update conversation
      debugPrint('[MessagingService] Updating conversation...');
      final updatedMessageIds = [...conversation.messageIds, messageId];
      debugPrint('[MessagingService] Updated message IDs: ${updatedMessageIds.length} total');
      
      await _conversationDb.update(
        conversationId,
        conversation.copyWith(
          messageIds: updatedMessageIds,
          lastMessageTimestamp: DateTime.now(),
        ),
        (c) => c.toJson(),
      );
      debugPrint('[MessagingService] Conversation updated successfully');

      // 4. Send notification if needed
      if (sendNotification) {
        debugPrint('[MessagingService] Preparing to send notification...');
        await _sendNewMessageNotification(
          recipientId: recipientId,
          content: content,
          conversationId: conversationId,
          messageId: messageId,
          senderId: senderId,
        );
        debugPrint('[MessagingService] Notification sent');
      }

      debugPrint('[MessagingService] Message process completed successfully');
    } catch (e, stack) {
      debugPrint('[MessagingService] ERROR in sendMessage: $e');
      debugPrint('[MessagingService] Stack trace: $stack');
      rethrow;
    }
  }

  Future<void> _sendNewMessageNotification({
    required String recipientId,
    required String content,
    required String conversationId,
    required String messageId,
    required String senderId,
  }) async {
    debugPrint('[MessagingService] Starting notification process');
    try {
      final notification = MyNotification.Notification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        userId: recipientId,
        title: 'New Message',
        body: content.length > 50 ? '${content.substring(0, 50)}...' : content,
        type: MyNotification.NotificationType.newMessage,
        isRead: false,
        payload: {
          'conversationId': conversationId,
          'messageId': messageId,
          'senderId': senderId,
          'hasAttachments': false,
        },
      );
      
      debugPrint('[MessagingService] Notification object created');
      debugPrint('  - Recipient: $recipientId');
      debugPrint('  - Content preview: ${notification.body}');
      
      await _notificationService.addNotification(notification);
      debugPrint('[MessagingService] Notification added successfully');
    } catch (e) {
      debugPrint('[MessagingService] ERROR in _sendNewMessageNotification: $e');
      rethrow;
    }
  }

  Stream<List<Message>> getMessages(String conversationId) {
    try {
      return _conversationDb.collectionRef
          .doc(conversationId)
          .snapshots()
          .asyncMap((conversationDoc) async {
            final conversation = conversationDoc.data();
            if (conversation == null) return [];

            final messages = await Future.wait(
              conversation.messageIds.map((id) => _messageDb.get(id)),
            );
            
            return messages
                .whereType<Message>()
                .toList()
                ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
          });
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return Stream.error(e);
    }
  }

  Future<String> getOrCreateConnection(String user1Id, String user2Id) async {
    // Sort IDs to avoid duplicates
    final ids = [user1Id, user2Id]..sort();
    final connectionId = 'conn_${ids.join('_')}';

    // Check if connection already exists
    final existing = await _connectionDb.get(connectionId);
    if (existing != null) return connectionId;

    // Create new connection
    final connection = Connection(
      id: connectionId,
      patientId: ids[0],
      healthcareProfessionalId: ids[1],
      date: DateTime.now(),
    );
    
    await _connectionDb.add(data: connection, id: connectionId);
    return connectionId;
  }

  Future<String> getOrCreateConversation(String connectionId) async {
    // Check for existing conversation first
    final query = await _conversationDb.collectionRef
        .where('connectionId', isEqualTo: connectionId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    // Create new conversation if none exists
    final conversationId = 'conv_${DateTime.now().millisecondsSinceEpoch}';
    final conversation = Conversation(
      id: conversationId,
      connectionId: connectionId,
      messageIds: [],
      lastMessageTimestamp: DateTime.now(),
    );
    
    await _conversationDb.add(data: conversation, id: conversationId);
    return conversationId;
  }

  Future<void> markMessageAsRead({
    required String messageId,
    required String currentUserId,
    bool notifySender = false,
  }) async {
    try {
      final message = await _messageDb.get(messageId);
      if (message != null && !message.isRead) {
        // Update message as read
        await _messageDb.update(
          messageId,
          message.copyWith(isRead: true),
          (m) => m.toJson(),
        );

        // Notify sender if requested
        if (notifySender && message.senderId != currentUserId) {
          await _notificationService.addNotification(
            MyNotification.Notification(
              id: 'notif_read_${DateTime.now().millisecondsSinceEpoch}',
              userId: message.senderId,
              title: 'Message Read',
              body: 'Your message has been read',
              type: MyNotification.NotificationType.systemAlert,
              isRead: false,
              payload: {
                'messageId': messageId,
                'readBy': currentUserId,
              },
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error marking message as read: $e');
      rethrow;
    }
  }

  Stream<int> getUnreadCount(String conversationId, String currentUserId) {
    return getMessages(conversationId)
        .map((messages) => messages.where((m) => !m.isRead && m.senderId != currentUserId).length)
        .handleError((e) {
          debugPrint('Error getting unread count: $e');
          return 0;
        });
  }
}