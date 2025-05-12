class Comment {
  final String id;
  final String patientId;
  final String patientName; // New field added
  final String healthcareProfessionalId;
  final String comment;
  final DateTime date;

  Comment({
    required this.id,
    required this.patientId,
    required this.patientName, // Added to constructor
    required this.comment,
    required this.healthcareProfessionalId,
    required this.date,
  });

  Comment copyWith({
    String? id,
    String? patientId,
    String? patientName, // Added to copyWith
    String? healthcareProfessionalId,
    String? comment,
    DateTime? date,
  }) {
    return Comment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName, // Added
      healthcareProfessionalId:
          healthcareProfessionalId ?? this.healthcareProfessionalId,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName, // Added to serialization
      'healthcareProfessionalId': healthcareProfessionalId,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      patientId: json['patientId'],
      patientName: json['patientName'] ?? 'Utilisateur', // Added with fallback
      healthcareProfessionalId: json['healthcareProfessionalId'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, patientId: $patientId, '
        'patientName: $patientName, ' // Added to toString
        'healthcareProfessionalId: $healthcareProfessionalId, '
        'comment: $comment, date: $date)';
  }
}