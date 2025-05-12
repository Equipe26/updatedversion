class Rating {
  final String id;
  final String patientId;
  final String healthcareProfessionalId;
  final double ratingValue;
  final String? comment;
  final DateTime date;

  Rating({
    required this.id,
    required this.patientId,
    required this.healthcareProfessionalId,
    required this.ratingValue,
    this.comment,
    required this.date,
  }) : assert(
         ratingValue >= 0 && ratingValue <= 5,
         'Rating must be between 0 and 5',
       );

  Rating copyWith({
    String? id,
    String? patientId,
    String? healthcareProfessionalId,
    double? ratingValue,
    String? comment,
    DateTime? date,
  }) {
    return Rating(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      healthcareProfessionalId:
          healthcareProfessionalId ?? this.healthcareProfessionalId,
      ratingValue: ratingValue ?? this.ratingValue,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'healthcareProfessionalId': healthcareProfessionalId,
      'ratingValue': ratingValue,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      patientId: json['patientId'],
      healthcareProfessionalId: json['healthcareProfessionalId'],
      ratingValue: json['ratingValue'].toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  @override
  String toString() {
    return 'Rating(id: $id, patientId: $patientId, healthcareProfessionalId: $healthcareProfessionalId, '
        'ratingValue: $ratingValue, comment: $comment, date: $date)';
  }
}
