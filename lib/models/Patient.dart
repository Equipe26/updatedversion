import 'User.dart';
import 'MedicalDocument.dart';
import 'HealthcareProfessional.dart';

class Patient extends User {
  final List<MedicalDocument> medicalRecord;
  final List<String> appointmentIds;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyServicesPhone;
  final List<String> notificationIds;
  final List<String> favoriteHealthcareProfessionalIds; // New field
  final List<String> favoriteMedicalDocumentIds;       // New field

  Patient({
    required String id,
    required String name,
    required String email,
    required String password,
    required String location,
    required this.medicalRecord,
    required this.appointmentIds,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    this.emergencyServicesPhone = '14',
    this.notificationIds = const [],
    this.favoriteHealthcareProfessionalIds = const [], // Initialize as empty
    this.favoriteMedicalDocumentIds = const [],        // Initialize as empty
  }) : super(
    id: id,
    name: name,
    email: email,
    password: password,
    location: location,
    role: Role.patient,
  );

  @override
  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? location,
    Role? role,
    List<MedicalDocument>? medicalRecord,
    List<String>? appointmentIds,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyServicesPhone,
    List<String>? notificationIds,
    List<String>? favoriteHealthcareProfessionalIds, // New in copyWith
    List<String>? favoriteMedicalDocumentIds,       // New in copyWith
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password ?? '',
      location: location ?? this.location ?? '',
      medicalRecord: medicalRecord ?? this.medicalRecord,
      appointmentIds: appointmentIds ?? this.appointmentIds,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyServicesPhone: emergencyServicesPhone ?? this.emergencyServicesPhone,
      notificationIds: notificationIds ?? this.notificationIds,
      favoriteHealthcareProfessionalIds: favoriteHealthcareProfessionalIds ?? this.favoriteHealthcareProfessionalIds,
      favoriteMedicalDocumentIds: favoriteMedicalDocumentIds ?? this.favoriteMedicalDocumentIds,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'medicalRecord': medicalRecord.map((doc) => doc.toJson()).toList(),
      'appointmentIds': appointmentIds,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyServicesPhone': emergencyServicesPhone,
      'notificationIds': notificationIds,
      'favoriteHealthcareProfessionalIds': favoriteHealthcareProfessionalIds, // New in toJson
      'favoriteMedicalDocumentIds': favoriteMedicalDocumentIds,              // New in toJson
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      location: json['location'],
      medicalRecord: (json['medicalRecord'] as List)
          .map((doc) => MedicalDocument.fromJson(doc))
          .toList(),
      appointmentIds: List<String>.from(json['appointmentIds']),
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      emergencyServicesPhone: json['emergencyServicesPhone'] ?? '112',
      notificationIds: List<String>.from(json['notificationIds'] ?? []),
      favoriteHealthcareProfessionalIds: List<String>.from(json['favoriteHealthcareProfessionalIds'] ?? []), // New in fromJson
      favoriteMedicalDocumentIds: List<String>.from(json['favoriteMedicalDocumentIds'] ?? []),              // New in fromJson
    );
  }

  get profilePicture => null;

  @override
  String toString() {
    return 'Patient(id: $id, name: $name, email: $email, password: ****, '
        'location: $location, medicalRecords: ${medicalRecord.length}, '
        'appointments: ${appointmentIds.length}, '
        'notifications: ${notificationIds.length}, '
        'favoriteProfessionals: ${favoriteHealthcareProfessionalIds.length}, '  // New in toString
        'favoriteDocuments: ${favoriteMedicalDocumentIds.length}, '             // New in toString
        'emergencyContact: $emergencyContactName ($emergencyContactPhone), '
        'emergencyServicesPhone: $emergencyServicesPhone)';
  }
}