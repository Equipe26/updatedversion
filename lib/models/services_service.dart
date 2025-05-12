import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import '../models/Service.dart';

class ServicesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _servicesCollection = 
      FirebaseFirestore.instance.collection('services');
  final CollectionReference _pendingServicesCollection = 
      FirebaseFirestore.instance.collection('pending_services');

  // Get all approved services
  Future<List<Service>> getApprovedServices() async {
    try {
      final querySnapshot = await _servicesCollection.get();
      return querySnapshot.docs
          .map((doc) => Service.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting services: $e');
      return [];
    }
  }

  // Add a new service (pending approval)
  Future<void> addPendingService(Service service) async {
    try {
      await _pendingServicesCollection.add(service.toJson());
    } catch (e) {
      print('Error adding pending service: $e');
      throw e;
    }
  }

  // Get services by healthcare type
  Future<List<Service>> getServicesByType(HealthcareType type) async {
    try {
      final querySnapshot = await _servicesCollection
          .where('healthcareType', isEqualTo: type.name)
          .get();
      return querySnapshot.docs
          .map((doc) => Service.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting services by type: $e');
      return [];
    }
  }
   Future<List<Service>> getServicesByProfessional(String professionalId) async {
    try {
      final querySnapshot = await _firestore
          .collection('services')
          .where('professionalId', isEqualTo: professionalId)
          .where('isApproved', isEqualTo: true)
          .get();
      
      return querySnapshot.docs.map((doc) => Service.fromDocument(doc)).toList();
    } catch (e) {
      print('Error getting professional services: $e');
      return [];
    }
  }

  Future<void> addService(Service service) async {
    try {
      await _firestore.collection('services').add(service.toJson());
    } catch (e) {
      print('Error adding service: $e');
      throw e;
    }
  }
Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection('services').doc(serviceId).delete();
    } catch (e) {
      print('Error deleting service: $e');
      throw e;
    }
  }
}