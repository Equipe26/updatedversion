import 'package:flutter/material.dart';

enum AppointmentStatus {
  scheduled,
  completed,
  canceled,
}

class Appointment {
  final String id;
  final String patientId;
  final String healthcareProfessionalId;
  final String serviceId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.healthcareProfessionalId,
    required this.serviceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = AppointmentStatus.scheduled,
  });

  // Convert enum to string for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'healthcareProfessionalId': healthcareProfessionalId,
      'serviceId': serviceId,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'status': status.name, // Convert enum to string
    };
  }

  // Convert string back to enum when reading from Firestore
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      healthcareProfessionalId: json['healthcareProfessionalId'],
      serviceId: json['serviceId'],
      date: DateTime.parse(json['date']),
      startTime: _parseTime(json['startTime']),
      endTime: _parseTime(json['endTime']),
      status: AppointmentStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
    );
  }

  String? get specialty => null;

  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? healthcareProfessionalId,
    String? serviceId,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      healthcareProfessionalId:
          healthcareProfessionalId ?? this.healthcareProfessionalId,
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }



  @override
  String toString() {
    return 'Appointment(id: $id, patientId: $patientId, healthcareProfessionalId: $healthcareProfessionalId, serviceId: $serviceId, date: $date, startTime: $startTime, endTime: $endTime, status: $status)';
  }
}
