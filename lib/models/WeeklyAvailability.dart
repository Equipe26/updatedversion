extension _FormatHelpers on int {
  String toHourString() => toString().padLeft(2, '0') + ':00';
}


class WeeklyAvailability {
  final String id;
  final String healthcareProfessionalId;
  final Map<String, List<int>> availability;

  WeeklyAvailability({
    required this.id,
    required this.healthcareProfessionalId,
    required this.availability,
  }) {
    const daysOfWeek = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    for (final day in daysOfWeek) {
      availability.putIfAbsent(day, () => List.filled(24, 0));
    }

    for (final entry in availability.entries) {
      if (entry.value.length != 24) {
        throw ArgumentError('Each day must have exactly 24 time slots');
      }
    }
  }

  String summary() {
    final buffer = StringBuffer();

    for (final day in availability.keys) {
      final hours = availability[day]!;
      final ranges = <String>[];

      int? start;
      for (int i = 0; i <= 24; i++) {
        if (i < 24 && hours[i] == 1) {
          start ??= i;
        } else {
          if (start != null) {
            ranges.add('${start.toHourString()}–${i.toHourString()}');
            start = null;
          }
        }
      }

      if (ranges.isNotEmpty) {
        buffer.writeln('$day: ${ranges.join(', ')}');
      }
    }

    return buffer.toString().trim();
  }

  WeeklyAvailability copyWith({
    String? id,
    String? healthcareProfessionalId,
    Map<String, List<int>>? availability,
  }) {
    return WeeklyAvailability(
      id: id ?? this.id,
      healthcareProfessionalId: healthcareProfessionalId ?? this.healthcareProfessionalId,
      availability: availability ?? Map.from(this.availability),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'healthcareProfessionalId': healthcareProfessionalId,
      'availability': availability,
    };
  }

  factory WeeklyAvailability.fromJson(Map<String, dynamic> json) {
    return WeeklyAvailability(
      id: json['id'],
      healthcareProfessionalId: json['healthcareProfessionalId'],
      availability: (json['availability'] as Map).map(
        (k, v) => MapEntry(k as String, List<int>.from(v)),
      ),
    );
  }

  bool isAvailable(String day, int hour) {
    if (hour < 0 || hour > 23) return false;
    return availability[day]?[hour] == 1 ?? false;
  }

  void setAvailable(String day, int hour, bool available) {
    if (hour >= 0 && hour < 24) {
      availability[day]?[hour] = available ? 1 : 0;
    }
  }

  String get openingHour {
    // Retourner l'heure d'ouverture si la pharmacie est ouverte
    return '08:00';
  }

  String get closingHour {
    // Retourner l'heure de fermeture si la pharmacie est ouverte
    return '18:00';
  }

  bool get isOpen {
    // Vérifie si la pharmacie est ouverte selon la disponibilité
    return availability['Monday']?[8] == 1; // Exemple: vérifie si l'heure 8h est disponible
  }
  bool isOpenForDay(String day) {
    final hours = availability[day];
    if (hours == null) return false;
    return hours.contains(1);  // Check if there is any available slot
  }
  @override
  String toString() {
    return 'WeeklyAvailability(id: $id, healthcareProfessionalId: $healthcareProfessionalId, '
        'availability: $availability)';
  }
}
