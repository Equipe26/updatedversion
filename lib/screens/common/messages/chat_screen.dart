import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/Message.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/models/MessagingService.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> otherParticipant;
  final String conversationId;
  final String connectionId;

  const ChatScreen({
    Key? key,
    required this.otherParticipant,
    required this.conversationId,
    required this.connectionId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _currentUserId;
  bool _isFirstBuild = true;
  List<String> _attachmentIds = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    _currentUserId = currentUser?.uid ?? '';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        left: isMe ? 80 : 8,
        right: isMe ? 8 : 80,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF1A73E8) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                if (message.attachmentIds.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildAttachmentsPreview(message.attachmentIds, isMe),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: message.isRead ? const Color.fromARGB(255, 42, 79, 109): Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsPreview(List<String> attachmentIds, bool isMe) {
    return Column(
      children: attachmentIds.map((id) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isMe ? Colors.white.withOpacity(0.2) : Colors.grey[100],
          ),
          child: ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: Text(
              'Attachment',
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: Text(
              'Tap to view',
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
              ),
            ),
            onTap: () {
              // TODO: Implement attachment viewing
              debugPrint('View attachment: $id');
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttachmentIndicator() {
    if (_attachmentIds.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color:  const Color.fromARGB(255, 42, 79, 109), size: 20),
          const SizedBox(width: 8),
          Text(
            '${_attachmentIds.length} attachment${_attachmentIds.length > 1 ? 's' : ''} ready',
            style: const TextStyle(color:  const Color.fromARGB(255, 42, 79, 109)),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color:  const Color.fromARGB(255, 42, 79, 109), size: 20),
            onPressed: () {
              setState(() {
                _attachmentIds.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagingService = Provider.of<MessagingService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherParticipant['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.otherParticipant['specialty'] != null &&
                    widget.otherParticipant['specialty'].isNotEmpty)
                  Text(
                    widget.otherParticipant['specialty'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data ?? [];
                
                if (messages.isNotEmpty && _isFirstBuild) {
                  _isFirstBuild = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _currentUserId;

                    if (!isMe && !message.isRead) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        messagingService.markMessageAsRead(
                          messageId: message.id,
                          currentUserId: _currentUserId,
                        );
                      });
                    }

                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          Column(
            children: [
              if (_attachmentIds.isNotEmpty) _buildAttachmentIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file, color:  const Color.fromARGB(255, 42, 79, 109)),
                      onPressed: _isUploading ? null : () => _attachFile(context),
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
                          contentPadding: 
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _isUploading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send, color:  const Color.fromARGB(255, 42, 79, 109)),
                            onPressed: () => _sendMessage(context),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _attachFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _isUploading = true;
        });

        final messagingService = 
            Provider.of<MessagingService>(context, listen: false);
        
        // TODO: Implement actual file upload logic
        // For now, we'll simulate upload with a delay
        await Future.delayed(const Duration(seconds: 1));
        
        // Generate mock attachment IDs
        final newAttachmentIds = List.generate(
          result.files.length,
          (index) => 'att_${DateTime.now().millisecondsSinceEpoch}_$index',
        );

        setState(() {
          _attachmentIds.addAll(newAttachmentIds);
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to attach files: $e')),
      );
    }
  }

  Future<void> _sendMessage(BuildContext context) async {
    final messageContent = _messageController.text.trim();
    if (messageContent.isEmpty && _attachmentIds.isEmpty) return;

    if (_currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to send messages')),
      );
      return;
    }

    final recipientId = widget.otherParticipant['id'];
    if (recipientId == null || recipientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid recipient')),
      );
      return;
    }

    final messagingService = Provider.of<MessagingService>(context, listen: false);
    
    try {
      await messagingService.sendMessage(
        connectionId: widget.connectionId, 
        conversationId: widget.conversationId,
        senderId: _currentUserId,
        recipientId: recipientId,
        content: messageContent,
        attachmentIds: _attachmentIds,
        sendNotification: true,
      );
      
      _messageController.clear();
      setState(() {
        _attachmentIds.clear();
      });
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: ${e.toString()}')),
      );
    }
  }
}