import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/Message.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/models/MessagingService.dart';

class ChatScreen extends StatefulWidget {
   final String connectionId;
  final String conversationId;
  final Map<String, dynamic> otherParticipant;

  const ChatScreen({
    super.key,
     required this.connectionId,
    required this.conversationId,
    required this.otherParticipant,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    _currentUserId = currentUser?.uid ?? '';
    debugPrint('[INIT] Current user ID: $_currentUserId');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[BUILD] Current user ID: $_currentUserId');
    debugPrint('[BUILD] Other participant ID: ${widget.otherParticipant['id']}');
    debugPrint('[BUILD] Conversation ID: ${widget.conversationId}');

    final messagingService = Provider.of<MessagingService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7ECFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF073057)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.otherParticipant['image'] != null &&
                      widget.otherParticipant['image'].isNotEmpty
                  ? NetworkImage(widget.otherParticipant['image'])
                  : null,
              child: widget.otherParticipant['image'] == null ||
                      widget.otherParticipant['image'].isEmpty
                  ? Text(
                      widget.otherParticipant['name'].isNotEmpty
                          ? widget.otherParticipant['name'][0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherParticipant['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF073057),
                  ),
                ),
                if (widget.otherParticipant['specialty'] != null &&
                    widget.otherParticipant['specialty'].isNotEmpty)
                  Text(
                    widget.otherParticipant['specialty'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF073057),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
         Expanded(
  child: StreamBuilder<List<Message>>(
    stream: messagingService.getMessages(widget.conversationId),
    builder: (context, snapshot) {
      debugPrint('[ChatScreen] StreamBuilder state:');
      debugPrint('  - ConnectionState: ${snapshot.connectionState}');
      debugPrint('  - HasError: ${snapshot.hasError}');
      debugPrint('  - HasData: ${snapshot.hasData}');
      
      if (snapshot.connectionState == ConnectionState.waiting) {
        debugPrint('[ChatScreen] StreamBuilder waiting for data');
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        debugPrint('[ChatScreen] Stream error: ${snapshot.error}');
        debugPrint('[ChatScreen] Stack trace: ${snapshot.stackTrace}');
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      final messages = snapshot.data ?? [];
      debugPrint('[ChatScreen] Received ${messages.length} messages');
      
      if (messages.isNotEmpty) {
        debugPrint('[ChatScreen] First message: ${messages.first.id}');
        debugPrint('[ChatScreen] Last message: ${messages.last.id}');
      }
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          debugPrint('[MESSAGE] ID: ${message.id} Sender: ${message.senderId} Content: ${message.content}');
          
          final isMe = message.senderId == _currentUserId;

          if (!isMe && !message.isRead) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              messagingService.markMessageAsRead(
                messageId: message.id,
                currentUserId: _currentUserId,
              );
            });
          }

          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFA3C3E4) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black54,
                    ),
                  ),
                  if (message.attachmentIds.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          '[${message.attachmentIds.length} attachment(s)]',
                          style: TextStyle(
                            fontSize: 12,
                            color: isMe
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black54,
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
    },
  ),
),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFF073057)),
                  onPressed: () => _attachFile(context),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFA3C3E4),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _attachFile(BuildContext context) async {
    debugPrint('[ATTACH FILE] Button pressed');
    // TODO: Implement file attachment logic
  }

  Future<void> _sendMessage(BuildContext context) async {
  debugPrint('[ChatScreen] _sendMessage initiated');
  debugPrint('[ChatScreen] Current user ID: $_currentUserId');
  
  final messageContent = _messageController.text.trim();
  if (messageContent.isEmpty) {
    debugPrint('[ChatScreen] Message content is empty - aborting');
    return;
  }

  if (_currentUserId.isEmpty) {
    debugPrint('[ChatScreen] No current user ID available');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to send messages')),
    );
    return;
  }

  final recipientId = widget.otherParticipant['id'];
  if (recipientId == null || recipientId.isEmpty) {
    debugPrint('[ChatScreen] Invalid recipient ID: $recipientId');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid recipient')),
    );
    return;
  }

  debugPrint('[ChatScreen] All pre-checks passed');
  debugPrint('[ChatScreen] Message details:');
  debugPrint('  - Sender: $_currentUserId');
  debugPrint('  - Recipient: $recipientId');
  debugPrint('  - Conversation ID: ${widget.conversationId}');
  debugPrint('  - Connection ID: ${widget.connectionId}');
  debugPrint('  - Content: ${messageContent.length > 50 ? messageContent.substring(0, 50) + "..." : messageContent}');

  final messagingService = Provider.of<MessagingService>(context, listen: false);
  
  try {
    debugPrint('[ChatScreen] Calling messagingService.sendMessage()');
    await messagingService.sendMessage(
      connectionId: widget.connectionId, 
      conversationId: widget.conversationId,
      senderId: _currentUserId,
      recipientId: recipientId,
      content: messageContent,
      sendNotification: true,
    );
    
    debugPrint('[ChatScreen] Message sent successfully');
    _messageController.clear();
    debugPrint('[ChatScreen] Message controller cleared');
  } catch (e, stackTrace) {
    debugPrint('[ChatScreen] ERROR sending message: $e');
    debugPrint('[ChatScreen] Stack trace: $stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send message: ${e.toString()}')),
    );
  }
}
}
