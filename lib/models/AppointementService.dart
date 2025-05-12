import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Appointment.dart';
import '../models/Notification.dart';
import '../database_service.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Patient.dart';
import 'Notification_service.dart';

class AppointmentService extends FirestoreService<Appointment> {
  final FirestoreService<HealthcareProfessional> _hpService;
  final FirestoreService<Patient> _patientService;
  final NotificationService _notificationService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppointmentService()
      : _hpService = FirestoreService<HealthcareProfessional>(
    collectionPath: 'healthcareProfessional',
    fromJson: HealthcareProfessional.fromJson,
    toJson: (hp) => hp.toJson(),
  ),
        _patientService = FirestoreService<Patient>(
          collectionPath: 'patients',
          fromJson: Patient.fromJson,
          toJson: (patient) => patient.toJson(),
        ),
        _notificationService = NotificationService(),
        super(
        collectionPath: 'appointments',
        fromJson: Appointment.fromJson,
        toJson: (appointment) => appointment.toJson(),
      );

  /// Returns a vector of 10 slots (8:00–17:00) where 1 indicates the slot is available
  /// (healthcare professional is available and no conflicting appointments exist),
  /// and 0 indicates the slot is unavailable.

Future<List<int>> checkAvailability({
  required String healthcareProfessionalId,
  required DateTime date,
}) async {
  try {
    // Step 1: Get healthcare professional with availability
    final hp = await _hpService.get(healthcareProfessionalId);
    if (hp == null) {
      return List.filled(10, 0); // No HP found, all slots unavailable
    }

    // Step 2: Get day of the week
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final dayOfWeek = daysOfWeek[date.weekday - 1];

    // Step 3: Get base availability vector for the day
final availabilityVector = 
    (hp.weeklyAvailability[int.tryParse(dayOfWeek) ?? 0] as List<int>?) 
    ?? List<int>.filled(10, 0);

    // Step 4: Check for conflicting appointments
    final appointments = await queryField(
      'healthcareProfessionalId',
      healthcareProfessionalId,
    );

    // Filter appointments for the specific date
    final conflictingAppointments = appointments.where((appt) {
      return appt.date.year == date.year &&
          appt.date.month == date.month &&
          appt.date.day == date.day &&
          appt.status != AppointmentStatus.canceled;
    }).toList();

    // Step 5: Mark slots with appointments as unavailable
    final finalVector = List<int>.from(availabilityVector);
    for (final appt in conflictingAppointments) {
      final slot = _timeToSlot(appt.startTime);
      if (slot >= 0 && slot < 10) {
        finalVector[slot] = 0;
      }
    }

    return finalVector;
  } catch (e) {
    print('Error checking availability: $e');
    return List.filled(10, 0); // Return all unavailable on error
  }
}
  /// Creates an appointment, adds it to patient and healthcare professional records,
  /// and sends confirmation notifications to both.
  Future<String> createAppointment({
    required String patientId,
    required String healthcareProfessionalId,
    required String serviceId,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    try {
      // Step 1: Verify availability
      final availabilityVector = await checkAvailability(
        healthcareProfessionalId: healthcareProfessionalId,
        date: date,
      );
      final slot = _timeToSlot(startTime);
      if (slot < 0 || slot >= 10 || availabilityVector[slot] == 0) {
        throw Exception('Selected time slot is not available');
      }

      // Step 2: Create appointment
      final appointmentId = _firestore.collection('appointments').doc().id;
      final appointment = Appointment(
        id: appointmentId,
        patientId: patientId,
        healthcareProfessionalId: healthcareProfessionalId,
        serviceId: serviceId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: AppointmentStatus.scheduled,
      );

      // Step 3: Use batch to update Firestore atomically
      final batch = _firestore.batch();

      // Add appointment to appointments collection
      final apptRef = collectionRef.doc(appointmentId);
      batch.set(apptRef, appointment);

      // Update patient's appointmentIds
      final patientRef = _patientService.collectionRef.doc(patientId);
      batch.update(patientRef, {
        'appointmentIds': FieldValue.arrayUnion([appointmentId]),
      });

      // Update healthcare professional's appointmentIds
      final hpRef = _hpService.collectionRef.doc(healthcareProfessionalId);
      batch.update(hpRef, {
        'appointmentIds': FieldValue.arrayUnion([appointmentId]),
      });

      // Commit batch
      await batch.commit();

      // Step 4: Send confirmation notifications
      await _sendConfirmationNotifications(
        appointment: appointment,
        patientId: patientId,
        healthcareProfessionalId: healthcareProfessionalId,
      );

      return appointmentId;
    } catch (e) {
      print('Error creating appointment: $e');
      throw Exception('Failed to create appointment: $e');
    }
  }

  /// Cancels an appointment, removes it from patient and healthcare professional records,
  /// and sends cancellation notifications to both.
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Step 1: Get appointment
      final appointment = await get(appointmentId);
      if (appointment == null) {
        throw Exception('Appointment not found');
      }

      // Step 2: Update appointment status to canceled
      final updatedAppointment = appointment.copyWith(status: AppointmentStatus.canceled);

      // Step 3: Use batch to update Firestore atomically
      final batch = _firestore.batch();

      // Update appointment status
      final apptRef = collectionRef.doc(appointmentId);
      batch.set(apptRef, updatedAppointment);

      // Remove from patient's appointmentIds
      final patientRef = _patientService.collectionRef.doc(appointment.patientId);
      batch.update(patientRef, {
        'appointmentIds': FieldValue.arrayRemove([appointmentId]),
      });

      // Remove from healthcare professional's appointmentIds
      final hpRef = _hpService.collectionRef.doc(appointment.healthcareProfessionalId);
      batch.update(hpRef, {
        'appointmentIds': FieldValue.arrayRemove([appointmentId]),
      });

      // Commit batch
      await batch.commit();

      // Step 4: Send cancellation notifications
      await _sendCancellationNotifications(
        appointment: updatedAppointment,
        patientId: appointment.patientId,
        healthcareProfessionalId: appointment.healthcareProfessionalId,
      );
    } catch (e) {
      print('Error canceling appointment: $e');
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  /// Helper: Converts TimeOfDay to slot index (8:00 = 0, 17:00 = 9)
  int _timeToSlot(TimeOfDay time) {
    final hour = time.hour;
    if (hour < 8 || hour > 17) return -1; // Invalid slot
    return hour - 8; // Maps 8:00 to slot 0, 17:00 to slot 9
  }

  /// Helper: Sends confirmation notifications to patient and healthcare professional
  Future<void> _sendConfirmationNotifications({
    required Appointment appointment,
    required String patientId,
    required String healthcareProfessionalId,
  }) async {
    final dateStr = appointment.date.toIso8601String().split('T')[0];
    final timeStr = '${appointment.startTime.hour}:${appointment.startTime.minute.toString().padLeft(2, '0')}';

    // Patient notification
    await _notificationService.sendNotification(
      userId: patientId,
      title: 'Appointment Confirmed',
      body: 'Your appointment on $dateStr at $timeStr has been confirmed.',
      type: NotificationType.appointmentConfirmation,
      payload: {'appointmentId': appointment.id},
    );

    // Healthcare professional notification
    await _notificationService.sendNotification(
      userId: healthcareProfessionalId,
      title: 'New Appointment Booked',
      body: 'A new appointment has been booked on $dateStr at $timeStr.',
      type: NotificationType.appointmentConfirmation,
      payload: {'appointmentId': appointment.id},
    );
  }

  /// Helper: Sends cancellation notifications to patient and healthcare professional
  Future<void> _sendCancellationNotifications({
    required Appointment appointment,
    required String patientId,
    required String healthcareProfessionalId,
  }) async {
    final dateStr = appointment.date.toIso8601String().split('T')[0];
    final timeStr = '${appointment.startTime.hour}:${appointment.startTime.minute.toString().padLeft(2, '0')}';

    // Patient notification
    await _notificationService.sendNotification(
      userId: patientId,
      title: 'Appointment Canceled',
      body: 'Your appointment on $dateStr at $timeStr has been canceled.',
      type: NotificationType.appointmentCancellation,
      payload: {'appointmentId': appointment.id},
    );

    // Healthcare professional notification
    await _notificationService.sendNotification(
      userId: healthcareProfessionalId,
      title: 'Appointment Canceled',
      body: 'The appointment on $dateStr at $timeStr has been canceled.',
      type: NotificationType.appointmentCancellation,
      payload: {'appointmentId': appointment.id},
    );
  }
}