class Conversation {
  final String id;
  final String connectionId;
  final List<String> messageIds; // Fixed variable name (singular "message")
  final DateTime lastMessageTimestamp;
  
  String? lastMessageContent;

  Conversation({
    required this.id,
    required this.connectionId,
    required this.messageIds, // Fixed parameter name
    required this.lastMessageTimestamp,
  });

  Conversation copyWith({
    String? id,
    String? connectionId,
    List<String>? messageIds, // Fixed parameter name
    DateTime? lastMessageTimestamp,
  }) {
    return Conversation(
      id: id ?? this.id,
      connectionId: connectionId ?? this.connectionId,
      messageIds: messageIds ?? this.messageIds, // Fixed field name
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'connectionId': connectionId,
      'messageIds': messageIds, // Just store IDs, no conversion needed
      'lastMessageTimestamp': lastMessageTimestamp.toIso8601String(),
    };
  }
  

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      connectionId: json['connectionId'],
      messageIds: List<String>.from(json['messageIds']), // Fixed field name
      lastMessageTimestamp: DateTime.parse(json['lastMessageTimestamp']),
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, connectionId: $connectionId, '
        'messageIds: ${messageIds.length}, ' // Fixed field name
        'lastMessageTimestamp: $lastMessageTimestamp)';
  }

  String? get lastMessagePreview {
    // Implement logic to get the last message preview
    // This could be stored in Firestore or calculated
    return lastMessageContent; // Or implement your own logic
  }

}
