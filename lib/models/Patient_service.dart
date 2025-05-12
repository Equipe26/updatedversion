import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database_service.dart';
import 'Appointment.dart';
import 'Patient.dart';
import 'MedicalDocument.dart';
import 'HealthcareProfessional.dart';


class PatientService {
  final FirestoreService<Patient> _patientFirestoreService;
  final FirestoreService<Appointment> _appointmentFirestoreService;
  final FirestoreService<HealthcareProfessional> _professionalFirestoreService;
  final FirestoreService<MedicalDocument> _documentFirestoreService;

  PatientService()
      : _patientFirestoreService = FirestoreService<Patient>(
    collectionPath: 'patients',

    fromJson: Patient.fromJson,
    toJson: (patient) => patient.toJson(),
  ),
        _appointmentFirestoreService = FirestoreService<Appointment>(
          collectionPath: 'appointments',
          fromJson: Appointment.fromJson,
          toJson: (appointment) => appointment.toJson(),
        ),
        _professionalFirestoreService = FirestoreService<HealthcareProfessional>(
          collectionPath: 'healthcareProfessional',
          fromJson: HealthcareProfessional.fromJson,
          toJson: (professional) => professional.toJson(),
        ),
        _documentFirestoreService = FirestoreService<MedicalDocument>(
          collectionPath: 'medicalDocuments',
          fromJson: MedicalDocument.fromJson,
          toJson: (document) => document.toJson(),
        );

  // Get patient appointments for a specific date
  Future<List<Appointment>> getPatientAppointmentsForDate({
    required String patientId,
    required DateTime date,
  }) async {
    try {
      final patient = await _patientFirestoreService.get(patientId);
      if (patient == null) return [];

      final appointments = await Future.wait(
        patient.appointmentIds.map((id) async {
          return await _appointmentFirestoreService.get(id);
        }),
      );

      return appointments.whereType<Appointment>().where((appt) {
        return appt.date.year == date.year &&
            appt.date.month == date.month &&
            appt.date.day == date.day;
      }).toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Emergency contact calls
  Future<void> callEmergencyContact(Patient patient) async {
    final phoneNumber = patient.emergencyContactPhone;
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> callEmergencyServices(Patient patient) async {
    final phoneNumber = patient.emergencyServicesPhone;
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Favorite management
 Future<void> addFavoriteHealthcareProfessional({
  required String patientId,
  required String professionalId,
}) async {
  try {
    await _patientFirestoreService.collectionRef.doc(patientId).update({
      'favoriteHealthcareProfessionalIds': FieldValue.arrayUnion([professionalId]),
    });
  } catch (e) {
    // If the field doesn't exist, create it first
    if (e.toString().contains('No field named')) {
      await _patientFirestoreService.collectionRef.doc(patientId).update({
        'favoriteHealthcareProfessionalIds': [professionalId],
      });
    } else {
      print('Error adding favorite professional: $e');
      throw e;
    }
  }
}

  Future<void> removeFavoriteHealthcareProfessional({
    required String patientId,
    required String professionalId,
  }) async {
    try {
      await _patientFirestoreService.collectionRef.doc(patientId).update({
        'favoriteHealthcareProfessionalIds': FieldValue.arrayRemove([professionalId]),
      });
    } catch (e) {
      print('Error removing favorite professional: $e');
      throw e;
    }
  }

  Future<void> addFavoriteMedicalDocument({
    required String patientId,
    required String documentId,
  }) async {
    try {
      await _patientFirestoreService.collectionRef.doc(patientId).update({
        'favoriteMedicalDocumentIds': FieldValue.arrayUnion([documentId]),
      });
    } catch (e) {
      print('Error adding favorite document: $e');
      throw e;
    }
  }

  Future<void> removeFavoriteMedicalDocument({
    required String patientId,
    required String documentId,
  }) async {
    try {
      await _patientFirestoreService.collectionRef.doc(patientId).update({
        'favoriteMedicalDocumentIds': FieldValue.arrayRemove([documentId]),
      });
    } catch (e) {
      print('Error removing favorite document: $e');
      throw e;
    }
  }

Future<List<HealthcareProfessional>> getFavoriteHealthcareProfessionals({
  required String patientId,
}) async {
  print('🔵 [DEBUG] 1. Starting favorites fetch for patient: $patientId');
  
  try {
    print('🔵 [DEBUG] 2. Fetching patient document...');
    final patient = await _patientFirestoreService.get(patientId);
    
    if (patient == null) {
      print('🔴 [DEBUG] 3. Patient document not found!');
      return [];
    }

    print('🟢 [DEBUG] 4. Patient found: ${patient.name}');
    print('📋 [DEBUG] 5. Favorite IDs: ${patient.favoriteHealthcareProfessionalIds}');
    print('📋 [DEBUG] 6. Favorite IDs type: ${patient.favoriteHealthcareProfessionalIds.runtimeType}');
    print('📋 [DEBUG] 7. First favorite ID: ${patient.favoriteHealthcareProfessionalIds.firstOrNull}');
    
    if (patient.favoriteHealthcareProfessionalIds.isEmpty) {
      print('🟡 [DEBUG] 8. No favorite IDs found');
      return [];
    }

    // Print each favorite ID with its details
    for (final id in patient.favoriteHealthcareProfessionalIds) {
      print('\n🔍 [ID ANALYSIS] Checking ID: "$id"');
      print('🔍 [ID ANALYSIS] ID length: ${id.length}');
      print('🔍 [ID ANALYSIS] ID code units: ${id.codeUnits}');
      print('🔍 [ID ANALYSIS] ID runtimeType: ${id.runtimeType}');
    }

    print('\n🔵 [DEBUG] 9. Fetching professional documents...');
    final professionals = await Future.wait(
      patient.favoriteHealthcareProfessionalIds.map((id) async {
        print('\n🟣 [FETCH] Attempting to fetch professional: "$id"');
        
        try {
          final professional = await _professionalFirestoreService.get(id);
          
          if (professional == null) {
            print('🔴 [FETCH] Professional "$id" not found!');
            // Additional debug to check Firestore directly
            final doc = await FirebaseFirestore.instance
                .collection('healthcareProfessionals')
                .doc(id)
                .get();
                
            print('📋 [FIRESTORE CHECK] Document exists? ${doc.exists}');
            if (!doc.exists) {
              print('🔴 [FIRESTORE CHECK] No document with exact ID "$id"');
              
              // Check for case-insensitive match
              final query = await FirebaseFirestore.instance
                  .collection('healthcareProfessionals')
                  .where('id', isEqualTo: id)
                  .limit(1)
                  .get();
                  
              print('🔍 [CASE CHECK] Case-insensitive matches: ${query.docs.length}');
            }
          }
          return professional;
        } catch (e) {
          print('🔴 [FETCH] Error fetching professional "$id": $e');
          return null;
        }
      }),
    );

    final validProfessionals = professionals.whereType<HealthcareProfessional>().toList();
    print('\n🟢 [DEBUG] 10. Found ${validProfessionals.length} valid professionals');
    
    return validProfessionals;
  } catch (e) {
    print('🔴 [DEBUG] 11. Error in getFavoriteHealthcareProfessionals: $e');
    return [];
  }
}

  Future<List<MedicalDocument>> getFavoriteMedicalDocuments({
    required String patientId,
  }) async {
    try {
      final patient = await _patientFirestoreService.get(patientId);
      if (patient == null) return [];

      final documents = await Future.wait(
        patient.favoriteMedicalDocumentIds.map((id) async {
          return await _documentFirestoreService.get(id);
        }),
      );

      return documents.whereType<MedicalDocument>().toList();
    } catch (e) {
      print('Error fetching favorite documents: $e');
      return [];
    }
  }

  Future<bool> isHealthcareProfessionalFavorite({
    required String patientId,
    required String professionalId,
  }) async {
    try {
      final patient = await _patientFirestoreService.get(patientId);
      if (patient == null) return false;
      return patient.favoriteHealthcareProfessionalIds.contains(professionalId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  Future<bool> isMedicalDocumentFavorite({
    required String patientId,
    required String documentId,
  }) async {
    try {
      final patient = await _patientFirestoreService.get(patientId);
      if (patient == null) return false;
      return patient.favoriteMedicalDocumentIds.contains(documentId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Additional helper methods
  Future<Patient?> getPatient(String id) async {
    return await _patientFirestoreService.get(id);
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String?> getPatientName(String patientId) async {
    try {
      final doc = await _firestore.collection('patients').doc(patientId).get();
      return doc.data()?['name']; // Supposons que le nom est stocké dans 'name'
    } catch (e) {
      print('Error getting patient name: $e');
      return null;
    }
  }

  Future<void> updatePatient(Patient patient) async {
    await _patientFirestoreService.update(patient.id, patient, (p) => p.toJson());
  }
Future<List<Patient>> getAllPatients() async {
  try {
    // Get all documents - FirestoreService will handle the conversion
    final patients = await _patientFirestoreService.getAll();
    
    print('Successfully fetched ${patients.length} patients');
    return patients;
  } catch (e) {
    print('Error fetching all patients: $e');
    return [];
  }
}
 
}