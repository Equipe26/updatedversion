class Connection {
  final String id;
  final String patientId;
  final String healthcareProfessionalId;
  final String? comment;
  final DateTime date;

  Connection({
    required this.id,
    required this.patientId,
    required this.healthcareProfessionalId,
    this.comment,
    required this.date,
  });

  Connection copyWith({
    String? id,
    String? patientId,
    String? healthcareProfessionalId,
    String? comment,
    DateTime? date,
  }) {
    return Connection(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
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
      'healthcareProfessionalId': healthcareProfessionalId,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      id: json['id'],
      patientId: json['patientId'],
      healthcareProfessionalId: json['healthcareProfessionalId'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  get patientName => null;

  get healthcareProfessionalName => null;

  get profileImageUrl => null;

  get specialty => null;

  @override
  String toString() {
    return 'Connection(id: $id, patientId: $patientId, healthcareProfessionalId: $healthcareProfessionalId, comment: $comment, date: $date)';
  }
}
