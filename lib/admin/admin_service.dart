import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Service.dart';
import '../models/Specialty.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all healthcare professionals that are pending validation
  Future<List<HealthcareProfessional>> getPendingHealthcareProfessionals() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'hp')
          .where('isValidatedByAdmin', isEqualTo: false)
          .get();

      List<HealthcareProfessional> pendingProfessionals = snapshot.docs
          .map((doc) => HealthcareProfessional.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return pendingProfessionals;
    } catch (e) {
      print('Error fetching pending healthcare professionals: $e');
      throw Exception('Failed to fetch pending healthcare professionals');
    }
  }

  // Approve a healthcare professional account and send notification email
  Future<void> approveHealthcareProfessional(String userId) async {
    try {
      // First get the healthcare professional data to access their email
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userEmail = userData['email'];
      String userName = userData['name'];
      
      // Update validation status
      await _firestore.collection('users').doc(userId).update({
        'isValidatedByAdmin': true,
        'validatedAt': FieldValue.serverTimestamp(),
      });
      
      // Call Cloud Function to send approval email
      await _firestore.collection('mail').add({
        'to': userEmail,
        'message': {
          'subject': 'Votre compte a été validé',
          'html': '''
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
              <div style="text-align: center; margin-bottom: 20px;">
                <img src="https://raw.githubusercontent.com/Asma-Jewel/app_data/main/chifaa_logo.png" alt="Logo" style="max-width: 200px;">
              </div>
              <h2 style="color: #396C9B; text-align: center;">Félicitations ${userName}!</h2>
              <p>Nous sommes heureux de vous informer que votre compte professionnel de santé a été validé par notre équipe administrative.</p>
              <p>Vous pouvez maintenant vous connecter à votre compte et commencer à utiliser tous les services de notre plateforme.</p>
              <div style="text-align: center; margin-top: 30px;">
                <a href="https://chifaa-app.web.app/login" style="background-color: #396C9B; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">Se connecter</a>
              </div>
              <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e0e0e0; color: #666; font-size: 12px;">
                <p>Si vous avez des questions, n'hésitez pas à contacter notre équipe de support à <a href="mailto:chifanoreply@gmail.com">chifanoreply@gmail.com</a>.</p>
                <p>Cordialement,<br>L'équipe Chifaa</p>
              </div>
            </div>
          ''',
        }
      });
      
      print('Healthcare professional approved and notified: $userId');
    } catch (e) {
      print('Error approving healthcare professional: $e');
      throw Exception('Failed to approve healthcare professional');
    }
  }

  // Deny a healthcare professional account, delete it, and send notification email
  Future<void> denyHealthcareProfessional(String userId) async {
    try {
      // First get the healthcare professional data to access their email
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userEmail = userData['email'];
      String userName = userData['name'];
      
      // Send denial email before deleting the account
      await _firestore.collection('mail').add({
        'to': userEmail,
        'message': {
          'subject': 'Information concernant votre demande de compte',
          'html': '''
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
              <div style="text-align: center; margin-bottom: 20px;">
                <img src="https://raw.githubusercontent.com/Asma-Jewel/app_data/main/chifaa_logo.png" alt="Logo" style="max-width: 200px;">
              </div>
              <h2 style="color: #396C9B; text-align: center;">Bonjour ${userName},</h2>
              <p>Nous vous remercions de l'intérêt que vous portez à notre plateforme.</p>
              <p>Après examen de votre demande, nous ne sommes malheureusement pas en mesure de valider votre compte professionnel de santé pour le moment.</p>
              <p>Cela peut être dû à l'une des raisons suivantes :</p>
              <ul>
                <li>Informations incomplètes ou incorrectes</li>
                <li>Documents requis manquants</li>
                <li>Impossibilité de vérifier vos qualifications professionnelles</li>
              </ul>
              <p>Pour toute question ou si vous souhaitez soumettre une nouvelle demande avec des informations mises à jour, n'hésitez pas à contacter notre équipe administrative à <a href="mailto:chifanoreply@gmail.com">chifanoreply@gmail.com</a>.</p>
              <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e0e0e0; color: #666; font-size: 12px;">
                <p>Cordialement,<br>L'équipe Chifaa</p>
              </div>
            </div>
          ''',
        }
      });
      
      // Delete the user account completely
      await _firestore.collection('users').doc(userId).delete();
      
      print('Healthcare professional denied, notified, and deleted: $userId');
    } catch (e) {
      print('Error denying healthcare professional: $e');
      throw Exception('Failed to deny healthcare professional');
    }
  }

  // Get all approved healthcare professionals
  Future<List<HealthcareProfessional>> getApprovedHealthcareProfessionals() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'hp')
          .where('isValidatedByAdmin', isEqualTo: true)
          .get();

      List<HealthcareProfessional> approvedProfessionals = snapshot.docs
          .map((doc) => HealthcareProfessional.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return approvedProfessionals;
    } catch (e) {
      print('Error fetching approved healthcare professionals: $e');
      throw Exception('Failed to fetch approved healthcare professionals');
    }
  }

  // Get healthcare professionals by type
  Future<List<HealthcareProfessional>> getHealthcareProfessionalsByType(HealthcareType type) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'hp')
          .where('type', isEqualTo: type.name)
          .get();

      List<HealthcareProfessional> professionals = snapshot.docs
          .map((doc) => HealthcareProfessional.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return professionals;
    } catch (e) {
      print('Error fetching healthcare professionals by type: $e');
      throw Exception('Failed to fetch healthcare professionals by type');
    }
  }

  // Get statistics about healthcare professionals
  Future<Map<String, dynamic>> getHealthcareProfessionalsStats() async {
    try {
      final Map<String, dynamic> stats = {};
      
      // Get total count
      final totalSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'hp')
          .count()
          .get();
      stats['total'] = totalSnapshot.count;

      // Get pending count
      final pendingSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'hp')
          .where('isValidatedByAdmin', isEqualTo: false)
          .count()
          .get();
      stats['pending'] = pendingSnapshot.count;

      // Get approved count
      final approvedSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'hp')
          .where('isValidatedByAdmin', isEqualTo: true)
          .count()
          .get();
      stats['approved'] = approvedSnapshot.count;

      // Get count by type
      stats['byType'] = {};
      for (HealthcareType type in HealthcareType.values) {
        final typeSnapshot = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'hp')
            .where('type', isEqualTo: type.name)
            .count()
            .get();
        stats['byType'][type.name] = typeSnapshot.count;
      }

      return stats;
    } catch (e) {
      print('Error fetching healthcare professionals stats: $e');
      throw Exception('Failed to fetch healthcare professionals stats');
    }
  }

  // Service Management Functions

  // Get all services
  Future<List<Map<String, dynamic>>> getAllServices() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('services')
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> services = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return services;
    } catch (e) {
      print('Error fetching services: $e');
      throw Exception('Failed to fetch services');
    }
  }

  // Get services by healthcare type
  Future<List<Map<String, dynamic>>> getServicesByType(HealthcareType type) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('services')
          .where('healthcareType', isEqualTo: type.name)
          .get();

      List<Map<String, dynamic>> services = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return services;
    } catch (e) {
      print('Error fetching services by type: $e');
      throw Exception('Failed to fetch services by type');
    }
  }

  // Get services by specialty (for médecin type)
  Future<List<Map<String, dynamic>>> getServicesBySpecialty(Specialty specialty) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('services')
          .where('healthcareType', isEqualTo: HealthcareType.medecin.name)
          .where('specialty', isEqualTo: specialty.name)
          .get();

      List<Map<String, dynamic>> services = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return services;
    } catch (e) {
      print('Error fetching services by specialty: $e');
      throw Exception('Failed to fetch services by specialty');
    }
  }

  // Add a new service
  Future<String> addService({
    required String name,
    required String description,
    required double price,
    required HealthcareType healthcareType,
    Specialty? specialty,
  }) async {
    try {
      // Validate that specialty is provided for médecin type
      if (healthcareType == HealthcareType.medecin && specialty == null) {
        throw Exception('Specialty must be provided for médecin services');
      }

      // Create a reference with auto-generated ID
      final DocumentReference serviceRef = _firestore.collection('services').doc();
      
      // Create service object
      final Map<String, dynamic> serviceData = {
        'id': serviceRef.id,
        'name': name,
        'description': description,
        'price': price,
        'healthcareType': healthcareType.name,
        'specialty': healthcareType == HealthcareType.medecin ? specialty?.name : null,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // Save to Firestore
      await serviceRef.set(serviceData);
      
      return serviceRef.id;
    } catch (e) {
      print('Error adding service: $e');
      throw Exception('Failed to add service: ${e.toString()}');
    }
  }

  // Update an existing service
  Future<void> updateService({
    required String serviceId,
    String? name,
    String? description,
    double? price,
  }) async {
    try {
      // Create update data map with only non-null values
      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (price != null) updateData['price'] = price;
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      
      // Update service in Firestore
      await _firestore
          .collection('services')
          .doc(serviceId)
          .update(updateData);
      
    } catch (e) {
      print('Error updating service: $e');
      throw Exception('Failed to update service');
    }
  }

  // Delete a service
  Future<void> deleteService(String serviceId) async {
    try {
      // Delete the service document
      await _firestore
          .collection('services')
          .doc(serviceId)
          .delete();
      
    } catch (e) {
      print('Error deleting service: $e');
      throw Exception('Failed to delete service');
    }
  }

  // Get statistics about services
  Future<Map<String, dynamic>> getServicesStats() async {
    try {
      final Map<String, dynamic> stats = {};
      
      // Get total service count
      final totalSnapshot = await _firestore
          .collection('services')
          .count()
          .get();
      stats['total'] = totalSnapshot.count;
      
      // Get count by healthcare type
      stats['byType'] = {};
      for (HealthcareType type in HealthcareType.values) {
        final typeSnapshot = await _firestore
            .collection('services')
            .where('healthcareType', isEqualTo: type.name)
            .count()
            .get();
        stats['byType'][type.name] = typeSnapshot.count;
      }
      
      return stats;
    } catch (e) {
      print('Error fetching services statistics: $e');
      throw Exception('Failed to fetch services statistics');
    }
  }

  // Get all users (both patients and healthcare professionals)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      // Get all users from the users collection
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('name')
          .get();

      // Convert to list of maps with additional type information
      List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        // Add document ID if it's not already in the data
        if (!userData.containsKey('id')) {
          userData['id'] = doc.id;
        }
        return userData;
      }).toList();

      return users;
    } catch (e) {
      print('Error fetching all users: $e');
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }

  // Get patients only
  Future<List<Map<String, dynamic>>> getPatients() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .orderBy('name')
          .get();

      List<Map<String, dynamic>> patients = snapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        if (!userData.containsKey('id')) {
          userData['id'] = doc.id;
        }
        return userData;
      }).toList();

      return patients;
    } catch (e) {
      print('Error fetching patients: $e');
      throw Exception('Failed to fetch patients: ${e.toString()}');
    }
  }

  // Delete a user (patient or healthcare professional)
  Future<void> deleteUser(String userId) async {
    try {
      // First, get the user to check their type
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      final String userRole = userData['role'];
      
      // For both types of users, we need to delete the user document
      await _firestore.collection('users').doc(userId).delete();
      
      // If it's a healthcare professional, we might need to clean up additional resources
      if (userRole == 'hp') {
        // You might want to:
        // - Delete or update appointments related to this healthcare professional
        // - Mark services as unavailable
        // - Send notifications to patients who had appointments with this HP
        // These would be additional steps in a production environment
      }
      
      // If it's a patient, we might need to clean up appointments, etc.
      if (userRole == 'patient') {
        // Clean up patient-related data if needed
        // - Delete patient appointments
        // - Delete medical records
      }
      
      print('User deleted successfully: $userId');
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }

  // Fetch the privacy policy content
  Future<Map<String, dynamic>> getPrivacyPolicy() async {
    try {
      DocumentSnapshot policyDoc = await _firestore.collection('app_settings').doc('privacy_policy').get();
      
      if (policyDoc.exists) {
        return policyDoc.data() as Map<String, dynamic>;
      } else {
        // Return default values if document doesn't exist
        return {
          'content': {},
          'lastUpdated': DateTime.now().toString(),
        };
      }
    } catch (e) {
      print('Error fetching privacy policy: $e');
      throw Exception('Failed to fetch privacy policy');
    }
  }

  // Update the privacy policy content
  Future<void> updatePrivacyPolicy(Map<String, dynamic> policyData) async {
    try {
      await _firestore.collection('app_settings').doc('privacy_policy').set({
        'content': policyData['content'],
        'lastUpdated': DateTime.now().toString(),
      }, SetOptions(merge: true));
      
      print('Privacy policy updated successfully');
    } catch (e) {
      print('Error updating privacy policy: $e');
      throw Exception('Failed to update privacy policy');
    }
  }

  // Initialize the privacy policy with default values if it doesn't exist
  Future<void> initializePrivacyPolicy() async {
    try {
      DocumentSnapshot policyDoc = await _firestore.collection('app_settings').doc('privacy_policy').get();
      
      if (!policyDoc.exists) {
        final Map<String, dynamic> defaultContent = {
          'intro': "La présente politique de confidentialité décrit la manière dont l'application Chifaa collecte, utilise, et protège vos données personnelles. Notre engagement est d'assurer la confidentialité et la sécurité de vos informations tout en vous offrant une expérience de santé optimale.",
          'description': "Chifaa est une application de santé qui facilite la mise en relation entre les patients et les professionnels de santé en Algérie, permettant la prise de rendez-vous, l'accès aux dossiers médicaux et la communication avec les prestataires de soins de santé.",
          'dataCollected': [
            "Données d'identification : nom, adresse e-mail, numéro de téléphone, adresse physique (wilaya, commune, adresse exacte)",
            "Données médicales : antécédents médicaux, documents médicaux (radiographies, analyses, ordonnances), rendez-vous médicaux",
            "Données professionnelles (pour les professionnels de santé) : numéro de licence, spécialités, services proposés, disponibilités, tarifs",
            "Données de localisation : localisation géographique pour faciliter la recherche de professionnels de santé à proximité",
            "Données d'utilisation : informations sur la manière dont vous utilisez l'application, préférences et favoris"
          ],
          'dataUsage': [
            "Fourniture de nos services : prise de rendez-vous, mise en relation avec des professionnels de santé, accès aux dossiers médicaux",
            "Amélioration de l'application : analyses statistiques anonymisées pour optimiser nos fonctionnalités et l'expérience utilisateur",
            "Communication : envoi d'informations importantes concernant vos rendez-vous, rappels médicaux et mises à jour de l'application",
            "Vérification des professionnels de santé : processus de validation administrative pour garantir l'authenticité des professionnels"
          ],
          'storageSecurity': [
            "Stockage sécurisé : vos données sont stockées sur des serveurs Firebase sécurisés avec des protocoles de cryptage modernes",
            "Contrôle d'accès : seules les personnes autorisées ont accès à vos informations médicales (votre médecin traitant, vous-même)",
            "Durée de conservation : nous conservons vos données aussi longtemps que nécessaire pour fournir nos services ou selon les exigences légales"
          ],
          'dataSharing': [
            "Professionnels de santé : nous partageons vos informations médicales uniquement avec les professionnels de santé que vous avez choisis",
            "Prestataires de services : nos partenaires techniques pour le fonctionnement de l'application (serveurs, services de notification) peuvent avoir un accès technique limité",
            "Obligations légales : nous pouvons être tenus de divulguer des informations pour respecter la loi ou protéger nos droits légaux"
          ],
          'userRights': [
            "Accès et rectification : vous pouvez accéder à vos données personnelles et les corriger via votre profil dans l'application",
            "Suppression : vous pouvez demander la suppression de votre compte et des données associées",
            "Limitation : vous pouvez demander la limitation du traitement de vos données dans certaines circonstances",
            "Portabilité : vous avez le droit de recevoir vos données dans un format structuré et couramment utilisé"
          ],
          'consent': "En utilisant l'application Chifaa, vous consentez à notre politique de confidentialité. Vous pouvez retirer votre consentement à tout moment en supprimant votre compte.",
          'dataSensitive': [
            "Conformité aux lois sur la santé : nous respectons les lois algériennes et internationales concernant la protection des données de santé",
            "Mesures de protection supplémentaires : les données médicales bénéficient de protections techniques et organisationnelles renforcées",
            "Anonymisation : nous anonymisons les données utilisées à des fins statistiques"
          ],
          'policyMod': "Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Toute modification sera publiée dans l'application et, si les changements sont significatifs, vous serez notifié directement.",
          'contact': "Pour toute question concernant cette politique de confidentialité ou vos données personnelles, veuillez nous contacter à chifanoreply@gmail.com"
        };
        
        await _firestore.collection('app_settings').doc('privacy_policy').set({
          'content': defaultContent,
          'lastUpdated': DateTime.now().toString(),
        });
        
        print('Privacy policy initialized with default values');
      }
    } catch (e) {
      print('Error initializing privacy policy: $e');
    }
  }
}