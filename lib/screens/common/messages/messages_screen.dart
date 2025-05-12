import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'new_message_screen.dart';
import 'chat_screen.dart';
import '../../../models/MessagingService.dart';
import '../../../models/Conversation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../login/connexion.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      // Return an empty container or loading screen
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUserId = currentUser.uid;
    final messagingService = Provider.of<MessagingService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7ECFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.chat_bubble, color: Color(0xFF073057)),
            SizedBox(width: 10),
            Text(
              'Messages',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF073057),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: messagingService.getUserConversations(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) {
            return const Center(child: Text('No conversations yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final otherParticipant = {
                'name': 'Participant Name',
                'image': 'https://placeholder.com/150',
              };

              return ConversationTile(
                conversation: conversation,
                otherParticipant: otherParticipant,
                currentUserId: currentUserId,
              );
            },
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA3C3E4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewMessageScreen()),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('New Message', style: TextStyle(color: Color(0xFF073057))),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Color(0xFF073057)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final Map<String, dynamic> otherParticipant;
  final String currentUserId;

  const ConversationTile({
    required this.conversation,
    required this.otherParticipant,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final messagingService = Provider.of<MessagingService>(context);

    return StreamBuilder<int>(
      stream: messagingService.getUnreadCount(conversation.id, currentUserId),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  connectionId:
                      conversation.connectionId, // Ajout du connectionId
                  conversationId: conversation.id,
                  otherParticipant: otherParticipant,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unreadCount > 0
                  ? const Color.fromARGB(255, 206, 219, 231)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(otherParticipant['image']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherParticipant['name'],
                        style: TextStyle(
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        conversation.lastMessagePreview ?? 'No messages yet',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _formatTime(conversation.lastMessageTimestamp),
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 135, 165, 196),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }
}