import 'User.dart';
import 'WeeklyAvailability.dart';
import 'Specialty.dart';
import 'Map.dart';

enum HealthcareType {
  medecin,
  clinique,
  centre_imagerie,
  laboratoire_analyse,
  infermier,
  pharmacie,
  dentiste;

  String displayName() {
    return name;
  }
}

enum Gender {
  male,
  female,
}

class HealthcareProfessional extends User {
  final HealthcareType type;
  final Specialty? specialty;
  final List<Specialty> availableSpecialties;
  final List<String> serviceIds;
  final List<WeeklyAvailability> weeklyAvailability;
  final List<String> ratingIds;
  final double rating;
  final List<String> commentIds;
  final List<String> appointmentIds;
  final List<String>? staffIds;
  final AlgerianWilayas wilaya;
  final AlgiersCommunes? commune;
  final String exactAddress;
  final List<String> notificationIds;
  final Gender gender;
  final bool isValidatedByAdmin;
  final String licenseNumber;
  HealthcareProfessional({
    required String id,
    required String name,
    required String email,
    required String password,
    required String location,
    required this.wilaya,
    this.commune,
    required this.exactAddress,
    required this.type,
    required this.gender,
    this.specialty,
    this.availableSpecialties = const [],
    this.serviceIds = const [],
    this.weeklyAvailability = const [],
    this.ratingIds = const [],
    this.commentIds = const [],
    this.appointmentIds = const [],
    this.staffIds,
    this.notificationIds = const [],
    this.rating = 0.0,
    this.isValidatedByAdmin = true,
    required this.licenseNumber,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          location: location,
          role: Role.healthcareProfessional,
        ) {
    if (type == HealthcareType.clinique) {
      if (availableSpecialties.isEmpty) {
        throw ArgumentError('Clinics must have at least one specialty');
      }
     
    
    }

    if ((type == HealthcareType.medecin || type == HealthcareType.dentiste) &&
        specialty == null) {
      throw ArgumentError('Doctors/dentists require a specialty');
    }

    // Only require commune if the wilaya is Alger
    if (wilaya == AlgerianWilayas.alger && commune == null) {
      throw ArgumentError('Commune is required for Alger wilaya');
    }
  }

  @override
  HealthcareProfessional copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? location,
    Role? role,
    HealthcareType? type,
    Specialty? specialty,
    List<Specialty>? availableSpecialties,
    List<String>? serviceIds,
    List<WeeklyAvailability>? weeklyAvailability,
    List<String>? ratingIds,
    double? rating,
    List<String>? commentIds,
    List<String>? appointmentIds,
    List<String>? staffIds,
    AlgerianWilayas? wilaya,
    AlgiersCommunes? commune,
    String? exactAddress,
    List<String>? notificationIds,
    Gender? gender,
    bool? isValidatedByAdmin,
    String? licenseNumber,
  }) {
    return HealthcareProfessional(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password ?? '',
      location: location ?? this.location ?? '',
      wilaya: wilaya ?? this.wilaya,
      commune: commune ?? this.commune,
      exactAddress: exactAddress ?? this.exactAddress,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      specialty: specialty ?? this.specialty,
      availableSpecialties: availableSpecialties ?? this.availableSpecialties,
      serviceIds: serviceIds ?? this.serviceIds,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      ratingIds: ratingIds ?? this.ratingIds,
      rating: rating ?? this.rating,
      commentIds: commentIds ?? this.commentIds,
      appointmentIds: appointmentIds ?? this.appointmentIds,
      staffIds: staffIds ?? this.staffIds,
      notificationIds: notificationIds ?? this.notificationIds,
      isValidatedByAdmin:
          isValidatedByAdmin ?? this.isValidatedByAdmin, // Added
      licenseNumber: licenseNumber ?? this.licenseNumber, // Added
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': type.name,
      'gender': gender.name,
      'specialty': specialty?.name,
      'availableSpecialties': availableSpecialties.map((s) => s.name).toList(),
      'serviceIds': serviceIds,
      'weeklyAvailability':
          weeklyAvailability.map((avail) => avail.toJson()).toList(),
      'ratingIds': ratingIds,
      'rating': rating,
      'commentIds': commentIds,
      'appointmentIds': appointmentIds,
      'staffIds': staffIds,
      'wilaya': wilaya.name,
      'commune': commune?.name,
      'exactAddress': exactAddress,
      'notificationIds': notificationIds,
      'isValidatedByAdmin': isValidatedByAdmin,
    };
  }

factory HealthcareProfessional.fromJson(Map<String, dynamic> json) {
  return HealthcareProfessional(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    location: json['location'],
    rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0, // Safely parse rating
    wilaya: AlgerianWilayas.values.firstWhere(
      (e) => e.name == json['wilaya'],
      orElse: () => AlgerianWilayas.alger,
    ),
    commune: json['commune'] != null
        ? AlgiersCommunes.values.firstWhere(
            (e) => e.name == json['commune'],
            orElse: () => AlgiersCommunes.values.first,
          )
        : null,
    exactAddress: json['exactAddress'],
    type: HealthcareType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => HealthcareType.medecin,
    ),
    gender: Gender.values.firstWhere(
      (e) => e.name == json['gender'],
      orElse: () => Gender.male,
    ),
    specialty: json['specialty'] != null
        ? Specialty.fromString(json['specialty'])
        : null,
    availableSpecialties: json['availableSpecialties'] != null
        ? (json['availableSpecialties'] as List)
            .map((s) => Specialty.fromString(s)!)
            .toList()
        : [],
    serviceIds: List<String>.from(json['serviceIds'] ?? []),
    weeklyAvailability: (json['weeklyAvailability'] as List? ?? [])
        .map((avail) => WeeklyAvailability.fromJson(avail))
        .toList(),
    ratingIds: List<String>.from(json['ratingIds'] ?? []),
    commentIds: List<String>.from(json['commentIds'] ?? []),
    appointmentIds: List<String>.from(json['appointmentIds'] ?? []),
    staffIds: json['staffIds'] != null
        ? List<String>.from(json['staffIds'])
        : null,
    notificationIds: List<String>.from(json['notificationIds'] ?? []),
    isValidatedByAdmin: json['isValidatedByAdmin'] ?? false,
    licenseNumber: json['licenseNumber'] ?? '',
  );
}


  bool get isClinic => type == HealthcareType.clinique;
  String get typeDisplay => typeDisplayMap[type] ?? type.name;
  bool get isDoctor => type == HealthcareType.medecin;
  static const typeDisplayMap = {
    HealthcareType.medecin: "Médecin",
    HealthcareType.clinique: "Clinique",
    HealthcareType.centre_imagerie: "Centre d'imagerie",
    HealthcareType.laboratoire_analyse: "Laboratoire d'analyse",
    HealthcareType.infermier: "Infirmier",
    HealthcareType.pharmacie: "Pharmacie",
    HealthcareType.dentiste: "Dentiste",
  };

  @override
  String toString() {
    return 'HealthcareProfessional('
        'id: $id, '
        'name: $name, '
        'type: ${type.name}, '
        'gender: ${gender.name}, '
        'specialty: ${specialty?.name}, '
        'rating: ${rating},'
        'availableSpecialties: ${availableSpecialties.map((s) => s.name)}, '
        'wilaya: ${wilaya.name}, '
        'commune: ${commune?.name}, '
        'location: $location, '
        'isValidatedByAdmin: $isValidatedByAdmin, ' // Added
        'notifications: ${notificationIds.length}, '
        'services: ${serviceIds.length}, '
        'staff: ${staffIds?.length ?? 0})';
      'licenseNumber: $licenseNumber'; // Added
  }
}
/*import 'User.dart';
import 'WeeklyAvailability.dart';
import 'Specialty.dart';

enum HealthcareType {
  medecin,
  clinique,
  centre_imagerie,
  laboratoire_analyse,
  infermier,
  pharmacie,
  dentiste,
}

class HealthcareProfessional extends User {
  final HealthcareType type;
  final Specialty? specialty;
  final List<Specialty> availableSpecialties;
  final List<String> serviceIds;
  final List<WeeklyAvailability> weeklyAvailability;
  final List<String> ratingIds;
  final List<String> commentIds;
  final List<String> appointmentIds;
  final List<String>? staffIds;
  final String? licenseNumber;
  final String wilaya;
  final String commune;
  final String exactAddress;
  final String location; // Full formatted location string
  final bool isValidatedByAdmin; // New field for admin validation status

  HealthcareProfessional({
    required String id,
    required String name,
    required String email,
    required String password,
    required this.wilaya,
    required this.commune,
    required this.exactAddress,
    required this.type,
    this.specialty,
    this.availableSpecialties = const [],
    required this.serviceIds,
    required this.weeklyAvailability,
    required this.ratingIds,
    required this.commentIds,
    required this.appointmentIds,
    this.staffIds,
    this.licenseNumber,
    required this.location, // Added to constructor
    this.isValidatedByAdmin = false, // Default to false for new accounts
  }) : super(
    id: id,
    name: name,
    email: email,
    password: password,
    location: '$wilaya, $commune, $exactAddress',
    role: 'hp',
  ) {
    if (type == HealthcareType.clinique) {
      if (availableSpecialties.isEmpty) {
        throw ArgumentError('Clinics must have at least one specialty');
      }
      if (staffIds == null || staffIds!.isEmpty) {
        throw ArgumentError('Clinics must have staff doctors');
      }
    }

    if ((type == HealthcareType.medecin || type == HealthcareType.dentiste) &&
        specialty == null) {
      throw ArgumentError('Doctors/dentists require a specialty');
    }
  }

  HealthcareProfessional copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? wilaya,
    String? commune,
    String? exactAddress,
    HealthcareType? type,
    Specialty? specialty,
    List<Specialty>? availableSpecialties,
    List<String>? serviceIds,
    List<WeeklyAvailability>? weeklyAvailability,
    List<String>? ratingIds,
    List<String>? commentIds,
    List<String>? appointmentIds,
    List<String>? staffIds,
    String? licenseNumber,
    String? location, // Added to copyWith
    bool? isValidatedByAdmin, // Added to copyWith
  }) {
    return HealthcareProfessional(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      wilaya: wilaya ?? this.wilaya,
      commune: commune ?? this.commune,
      exactAddress: exactAddress ?? this.exactAddress,
      type: type ?? this.type,
      specialty: specialty ?? this.specialty,
      availableSpecialties: availableSpecialties ?? this.availableSpecialties,
      serviceIds: serviceIds ?? this.serviceIds,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      ratingIds: ratingIds ?? this.ratingIds,
      commentIds: commentIds ?? this.commentIds,
      appointmentIds: appointmentIds ?? this.appointmentIds,
      staffIds: staffIds ?? this.staffIds,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      location: location ?? this.location, // Added
      isValidatedByAdmin: isValidatedByAdmin ?? this.isValidatedByAdmin, // Added
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': type.name,
      'specialty': specialty?.name,
      'availableSpecialties': availableSpecialties.map((s) => s.name).toList(),
      'serviceIds': serviceIds,
      'weeklyAvailability': weeklyAvailability.map((avail) => avail.toJson()).toList(),
      'ratingIds': ratingIds,
      'commentIds': commentIds,
      'appointmentIds': appointmentIds,
      'staffIds': staffIds,
      'licenseNumber': licenseNumber,
      'wilaya': wilaya,
      'commune': commune,
      'exactAddress': exactAddress,
      'location': location, // Added
      'isValidatedByAdmin': isValidatedByAdmin, // Added
    };
  }

  factory HealthcareProfessional.fromJson(Map<String, dynamic> json) {
    return HealthcareProfessional(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      wilaya: json['wilaya'],
      commune: json['commune'],
      exactAddress: json['exactAddress'],
      type: HealthcareType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => HealthcareType.medecin,
      ),
      specialty: json['specialty'] != null
          ? Specialty.fromString(json['specialty'])
          : null,
      availableSpecialties: json['availableSpecialties'] != null
          ? (json['availableSpecialties'] as List)
          .map((s) => Specialty.fromString(s)!)
          .toList()
          : [],
      serviceIds: List<String>.from(json['serviceIds']),
      weeklyAvailability: (json['weeklyAvailability'] as List)
          .map((avail) => WeeklyAvailability.fromJson(avail))
          .toList(),
      ratingIds: List<String>.from(json['ratingIds']),
      commentIds: List<String>.from(json['commentIds']),
      appointmentIds: List<String>.from(json['appointmentIds']),
      staffIds: json['staffIds'] != null ? List<String>.from(json['staffIds']) : null,
      licenseNumber: json['licenseNumber'],
      location: json['location'] ?? '${json['wilaya']}, ${json['commune']}, ${json['exactAddress']}', // Added with fallback
      isValidatedByAdmin: json['isValidatedByAdmin'] ?? false, // Added with fallback
    );
  }

  bool get isClinic => type == HealthcareType.clinique;
  String get typeDisplay => typeDisplayMap[type] ?? type.name;

  static const typeDisplayMap = {
    HealthcareType.medecin: "Médecin",
    HealthcareType.clinique: "Clinique",
    HealthcareType.centre_imagerie: "Centre d'imagerie",
    HealthcareType.laboratoire_analyse: "Laboratoire d'analyse",
    HealthcareType.infermier: "Infirmier",
    HealthcareType.pharmacie: "Pharmacie",
    HealthcareType.dentiste: "Dentiste",
  };

  @override
  String toString() {
    return 'HealthcareProfessional('
        'id: $id, '
        'name: $name, '
        'type: ${type.name}, '
        'specialty: ${specialty?.name}, '
        'availableSpecialties: ${availableSpecialties.map((s) => s.name)}, '
        'wilaya: $wilaya, '
        'commune: $commune, '
        'location: $location, ' // Added
        'isValidatedByAdmin: $isValidatedByAdmin, ' // Added
        'services: ${serviceIds.length}, '
        'staff: ${staffIds?.length ?? 0})';
  }
}*/
