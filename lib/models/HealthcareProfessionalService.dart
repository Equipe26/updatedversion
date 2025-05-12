import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../database_service.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Map.dart';
import '../models/Specialty.dart';

class HealthcareProfessionalService extends FirestoreService<HealthcareProfessional> {
  HealthcareProfessionalService()
      : super(
    collectionPath: 'healthcareProfessional',
    fromJson: HealthcareProfessional.fromJson,
    toJson: (professional) => professional.toJson(),
  );

  Future<List<HealthcareProfessional>> getAll() async {
    try {
      debugPrint('Fetching all healthcare professionals');
      final querySnapshot = await collectionRef.get();
      debugPrint('Fetched ${querySnapshot.docs.length} documents');
      final results = querySnapshot.docs.map((doc) {
        try {
          return doc.data();
        } catch (e) {
          debugPrint('Error parsing doc ${doc.id}: $e');
          return null;
        }
      }).whereType<HealthcareProfessional>().toList();
      debugPrint('Returning ${results.length} professionals');
      return results;
    } catch (e) {
      debugPrint('Get all error: $e');
      return [];
    }
  }

  Future<List<HealthcareProfessional>> searchByName(String query) async {
    try {
      debugPrint('Starting name search for: "$query"');
      final normalizedQuery = _normalizeString(query);
      if (normalizedQuery.isEmpty) {
        debugPrint('Empty query after normalization');
        return [];
      }

      final allDocs = await collectionRef.get();
      debugPrint('Fetched ${allDocs.docs.length} documents');

      final searchTerms = normalizedQuery.split(' ').where((t) => t.isNotEmpty).toList();
      debugPrint('Search terms: $searchTerms');

      final results = allDocs.docs.map((doc) {
        try {
          return doc.data();
        } catch (e) {
          debugPrint('Error parsing doc ${doc.id}: $e');
          return null;
        }
      }).whereType<HealthcareProfessional>().where((hp) {
        final normalizedName = _normalizeString(hp.name);
        final matches = searchTerms.every((term) => normalizedName.contains(term));
        if (kDebugMode) {
          debugPrint('Checking "${hp.name}" (normalized: $normalizedName) - matches: $matches');
        }
        return matches;
      }).toList();

      debugPrint('Found ${results.length} results');
      return results;
    } catch (e) {
      debugPrint('Name search error: $e');
      return [];
    }
  }

  Future<List<HealthcareProfessional>> searchWithFilters({
    HealthcareType? type,
    Specialty? specialty,
    Gender? gender,
    AlgerianWilayas? wilaya,
    AlgiersCommunes? commune,
  }) async {
    try {
      debugPrint('Starting filter search with: '
          'type: ${type?.name}, '
          'specialty: ${specialty?.name}, '
          'gender: ${gender?.name}, '
          'wilaya: ${wilaya?.name}, '
          'commune: ${commune?.name}');

      Query<HealthcareProfessional> query = collectionRef;

      if (type != null) {
        query = query.where('type', isEqualTo: type.name);
        debugPrint('Applied type filter: ${type.name}');
      }
      if (gender != null) {
        query = query.where('gender', isEqualTo: gender.name);
        debugPrint('Applied gender filter: ${gender.name}');
      }
      if (wilaya != null) {
        query = query.where('wilaya', isEqualTo: wilaya.name);
        debugPrint('Applied wilaya filter: ${wilaya.name}');
      }
      if (commune != null) {
        query = query.where('commune', isEqualTo: commune.name);
        debugPrint('Applied commune filter: ${commune.name}');
      }

      final querySnapshot = await query.get();
      debugPrint('Found ${querySnapshot.docs.length} documents after basic filters');

      var results = querySnapshot.docs.map((doc) {
        try {
          return doc.data();
        } catch (e) {
          debugPrint('Error parsing doc ${doc.id}: $e');
          return null;
        }
      }).whereType<HealthcareProfessional>().toList();

      if (specialty != null) {
        debugPrint('Applying specialty filter for: ${specialty.name}');
        results = results.where((hp) {
          final hasSpecialty = _hasSpecialty(hp, specialty);
          if (kDebugMode) {
            debugPrint('Professional ${hp.name} (${hp.type.name}) - '
                'Primary specialty: ${hp.specialty?.name}, '
                'Available specialties: ${hp.availableSpecialties.map((s) => s.name)}, '
                'Matches: $hasSpecialty');
          }
          return hasSpecialty;
        }).toList();
        debugPrint('${results.length} results after specialty filter');
      }

      return results;
    } catch (e) {
      debugPrint('Filter search error: $e');
      return [];
    }
  }

  bool _hasSpecialty(HealthcareProfessional hp, Specialty specialty) {
    final targetSpecialty = _normalizeString(specialty.name);

    if ((hp.type == HealthcareType.medecin || hp.type == HealthcareType.dentiste) &&
        hp.specialty != null) {
      final primarySpecialty = _normalizeString(hp.specialty!.name);
      if (primarySpecialty == targetSpecialty) return true;
    }

    if (hp.type == HealthcareType.clinique) {
      return hp.availableSpecialties.any((s) =>
      _normalizeString(s.name) == targetSpecialty);
    }

    return false;
  }

  String _normalizeString(String input) {
    if (input.isEmpty) return input;

    return input
        .trim()
        .toLowerCase()
        .replaceAllMapped(RegExp(r'[éèêë]'), (match) => 'e')
        .replaceAllMapped(RegExp(r'[àâä]'), (match) => 'a')
        .replaceAllMapped(RegExp(r'[îï]'), (match) => 'i')
        .replaceAllMapped(RegExp(r'[ôö]'), (match) => 'o')
        .replaceAllMapped(RegExp(r'[ùûü]'), (match) => 'u')
        .replaceAllMapped(RegExp(r'[ç]'), (match) => 'c')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}