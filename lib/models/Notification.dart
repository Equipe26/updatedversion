enum NotificationType {
  appointmentReminder,
  appointmentConfirmation,
  appointmentCancellation,
  systemAlert,
  newMessage,
  ratingReminder,
}

class Notification {
  final String id;
  final String userId; // Recipient ID
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? payload; // Additional data

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    DateTime? createdAt,
    this.isRead = false,
    this.payload,
  }) : createdAt = createdAt ?? DateTime.now();

  // CopyWith
  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? payload,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  // ToJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'payload': payload,
    };
  }

  // FromJson
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => NotificationType.systemAlert,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      payload: json['payload'],
    );
  }

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, type: ${type.name}, isRead: $isRead)';
  }
}